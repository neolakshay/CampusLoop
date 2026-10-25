import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Application rules for campus activities and RSVPs.
///
/// Endpoint methods stay thin; all identity, validation, capacity, and
/// ownership decisions are made on the server here.
abstract final class ActivityService {
  static const int _maxPageSize = 30;
  static const int _minCapacity = 2;
  static const int _maxCapacity = 100;

  static Future<List<CampusActivity>> listUpcoming(
    Session session, {
    required ActivityKind? kind,
    required int limit,
    required int offset,
  }) async {
    _validatePage(limit: limit, offset: offset);
    final now = DateTime.now().toUtc();

    return CampusActivity.db.find(
      session,
      where: (t) {
        final activeFuture =
            t.status.equals(ActivityStatus.active) & (t.startsAt >= now);
        final requestedKind = kind;
        if (requestedKind == null) {
          return activeFuture;
        }
        return activeFuture & t.kind.equals(requestedKind);
      },
      orderByList: (t) => [t.startsAt.asc(), t.id.asc()],
      limit: limit,
      offset: offset,
    );
  }

  static Future<ActivityDetails?> getActivity(
    Session session,
    int activityId,
  ) async {
    final activity = await CampusActivity.db.findById(session, activityId);
    if (activity == null) {
      return null;
    }

    final userIdentifier = _currentUserIdentifier(session);
    return _details(session, activity, userIdentifier);
  }

  static Future<ActivityDetails> createActivity(
    Session session,
    CreateActivityRequest request,
  ) async {
    final userIdentifier = _currentUserIdentifier(session);
    final values = _validateCreateRequest(request);

    return session.db.transaction((transaction) async {
      final activity = await CampusActivity.db.insertRow(
        session,
        CampusActivity(
          kind: request.kind,
          title: values.title,
          description: values.description,
          topic: values.topic,
          startsAt: values.startsAt,
          endsAt: values.endsAt,
          location: values.location,
          capacity: request.capacity,
          organizerName: values.organizerName,
          createdByUserIdentifier: userIdentifier,
          createdAt: DateTime.now().toUtc(),
          status: ActivityStatus.active,
          isDemo: false,
        ),
        transaction: transaction,
      );

      final activityId = activity.id;
      if (activityId == null) {
        throw StateError('The saved activity did not receive a database id.');
      }

      await ActivityRsvp.db.insertRow(
        session,
        ActivityRsvp(
          activityId: activityId,
          userIdentifier: userIdentifier,
          joinedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );

      return _details(
        session,
        activity,
        userIdentifier,
        transaction: transaction,
      );
    });
  }

  static Future<ActivityDetails> joinActivity(
    Session session,
    int activityId,
  ) async {
    final userIdentifier = _currentUserIdentifier(session);

    return session.db.transaction((transaction) async {
      final activity = await CampusActivity.db.findById(
        session,
        activityId,
        lockMode: LockMode.forUpdate,
        transaction: transaction,
      );
      if (activity == null) {
        throw _error(
          ActivityErrorCode.notFound,
          'This activity could not be found.',
        );
      }
      if (activity.status != ActivityStatus.active) {
        throw _error(
          ActivityErrorCode.closed,
          'This activity has been cancelled.',
        );
      }
      if (!activity.startsAt.isAfter(DateTime.now().toUtc())) {
        throw _error(
          ActivityErrorCode.closed,
          'This activity has already started.',
        );
      }

      final existingRsvp = await _findRsvp(
        session,
        activityId,
        userIdentifier,
        transaction: transaction,
      );
      if (existingRsvp != null) {
        return _details(
          session,
          activity,
          userIdentifier,
          transaction: transaction,
        );
      }

      final attendeeCount = await _attendeeCount(
        session,
        activityId,
        transaction: transaction,
      );
      final capacity = activity.capacity;
      if (capacity != null && attendeeCount >= capacity) {
        throw _error(
          ActivityErrorCode.full,
          'This activity has no places remaining.',
        );
      }

      await ActivityRsvp.db.insertRow(
        session,
        ActivityRsvp(
          activityId: activityId,
          userIdentifier: userIdentifier,
          joinedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );

      return _details(
        session,
        activity,
        userIdentifier,
        transaction: transaction,
      );
    });
  }

  static Future<ActivityDetails> leaveActivity(
    Session session,
    int activityId,
  ) async {
    final userIdentifier = _currentUserIdentifier(session);

    return session.db.transaction((transaction) async {
      final activity = await CampusActivity.db.findById(
        session,
        activityId,
        lockMode: LockMode.forUpdate,
        transaction: transaction,
      );
      if (activity == null) {
        throw _error(
          ActivityErrorCode.notFound,
          'This activity could not be found.',
        );
      }
      if (activity.createdByUserIdentifier == userIdentifier) {
        throw _error(
          ActivityErrorCode.organizerMustCancel,
          'Organizers must cancel their activity instead of leaving it.',
        );
      }

      final rsvp = await _findRsvp(
        session,
        activityId,
        userIdentifier,
        transaction: transaction,
      );
      if (rsvp != null) {
        await ActivityRsvp.db.deleteRow(
          session,
          rsvp,
          transaction: transaction,
        );
      }

      return _details(
        session,
        activity,
        userIdentifier,
        transaction: transaction,
      );
    });
  }

  static Future<ActivityDetails> cancelActivity(
    Session session,
    int activityId,
  ) async {
    final userIdentifier = _currentUserIdentifier(session);

    return session.db.transaction((transaction) async {
      final activity = await CampusActivity.db.findById(
        session,
        activityId,
        lockMode: LockMode.forUpdate,
        transaction: transaction,
      );
      if (activity == null) {
        throw _error(
          ActivityErrorCode.notFound,
          'This activity could not be found.',
        );
      }
      if (activity.createdByUserIdentifier != userIdentifier) {
        throw _error(
          ActivityErrorCode.forbidden,
          'Only the organizer can cancel this activity.',
        );
      }

      final cancelled = activity.status == ActivityStatus.cancelled
          ? activity
          : await CampusActivity.db.updateRow(
              session,
              activity.copyWith(status: ActivityStatus.cancelled),
              transaction: transaction,
            );

      return _details(
        session,
        cancelled,
        userIdentifier,
        transaction: transaction,
      );
    });
  }

  static Future<List<ActivityPlan>> listMyPlans(
    Session session, {
    required int limit,
    required int offset,
  }) async {
    _validatePage(limit: limit, offset: offset);
    final userIdentifier = _currentUserIdentifier(session);
    final now = DateTime.now().toUtc();

    final organizedActivities = await CampusActivity.db.find(
      session,
      where: (t) =>
          t.createdByUserIdentifier.equals(userIdentifier) &
          (t.startsAt >= now),
      orderByList: (t) => [t.startsAt.asc(), t.id.asc()],
    );

    final userRsvps = await ActivityRsvp.db.find(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      orderBy: (t) => t.joinedAt,
    );
    final rsvpByActivityId = <int, ActivityRsvp>{
      for (final rsvp in userRsvps) rsvp.activityId: rsvp,
    };
    final rsvpActivityIds = rsvpByActivityId.keys.toSet();

    final joinedActivities = rsvpActivityIds.isEmpty
        ? <CampusActivity>[]
        : await CampusActivity.db.find(
            session,
            where: (t) => t.id.inSet(rsvpActivityIds) & (t.startsAt >= now),
          );

    final activitiesById = <int, CampusActivity>{};
    for (final activity in organizedActivities) {
      final id = activity.id;
      if (id != null) {
        activitiesById[id] = activity;
      }
    }
    for (final activity in joinedActivities) {
      final id = activity.id;
      if (id != null) {
        activitiesById[id] = activity;
      }
    }

    final plans =
        activitiesById.entries.map((entry) {
          final activity = entry.value;
          final id = entry.key;
          return ActivityPlan(
            activity: activity,
            isOrganizer: activity.createdByUserIdentifier == userIdentifier,
            isAttending: rsvpByActivityId.containsKey(id),
            joinedAt: rsvpByActivityId[id]?.joinedAt,
          );
        }).toList()..sort((a, b) {
          final byStart = a.activity.startsAt.compareTo(b.activity.startsAt);
          if (byStart != 0) return byStart;
          return a.activity.id!.compareTo(b.activity.id!);
        });

    if (offset >= plans.length) {
      return <ActivityPlan>[];
    }
    final requestedEnd = offset + limit;
    final end = requestedEnd < plans.length ? requestedEnd : plans.length;
    return plans.sublist(offset, end);
  }

  static _CreateActivityValues _validateCreateRequest(
    CreateActivityRequest request,
  ) {
    final title = _requiredText(
      request.title,
      field: 'title',
      minimum: 3,
      maximum: 80,
    );
    final description = _requiredText(
      request.description,
      field: 'description',
      minimum: 10,
      maximum: 500,
    );
    final organizerName = _requiredText(
      request.organizerName,
      field: 'organizerName',
      minimum: 2,
      maximum: 40,
    );
    final location = _requiredText(
      request.location,
      field: 'location',
      minimum: 2,
      maximum: 100,
    );

    final topic = request.topic?.trim();
    final normalizedTopic = topic == null || topic.isEmpty ? null : topic;
    if (request.kind == ActivityKind.studySession && normalizedTopic == null) {
      throw _error(
        ActivityErrorCode.validation,
        'A study session needs a course or topic.',
        field: 'topic',
      );
    }
    if (normalizedTopic != null && normalizedTopic.length > 40) {
      throw _error(
        ActivityErrorCode.validation,
        'Topic must be 40 characters or fewer.',
        field: 'topic',
      );
    }

    final startsAt = request.startsAt.toUtc();
    final endsAt = request.endsAt?.toUtc();
    final now = DateTime.now().toUtc();
    if (!startsAt.isAfter(now)) {
      throw _error(
        ActivityErrorCode.validation,
        'Start time must be in the future.',
        field: 'startsAt',
      );
    }
    if (endsAt != null && !endsAt.isAfter(startsAt)) {
      throw _error(
        ActivityErrorCode.validation,
        'End time must be after the start time.',
        field: 'endsAt',
      );
    }

    final capacity = request.capacity;
    if (capacity != null &&
        (capacity < _minCapacity || capacity > _maxCapacity)) {
      throw _error(
        ActivityErrorCode.validation,
        'Capacity must be between $_minCapacity and $_maxCapacity.',
        field: 'capacity',
      );
    }

    return _CreateActivityValues(
      title: title,
      description: description,
      topic: normalizedTopic,
      startsAt: startsAt,
      endsAt: endsAt,
      location: location,
      organizerName: organizerName,
    );
  }

  static String _requiredText(
    String value, {
    required String field,
    required int minimum,
    required int maximum,
  }) {
    final normalized = value.trim();
    if (normalized.length < minimum || normalized.length > maximum) {
      throw _error(
        ActivityErrorCode.validation,
        '$field must be between $minimum and $maximum characters.',
        field: field,
      );
    }
    return normalized;
  }

  static void _validatePage({required int limit, required int offset}) {
    if (limit < 1 || limit > _maxPageSize) {
      throw _error(
        ActivityErrorCode.validation,
        'Page size must be between 1 and $_maxPageSize.',
        field: 'limit',
      );
    }
    if (offset < 0) {
      throw _error(
        ActivityErrorCode.validation,
        'Page offset cannot be negative.',
        field: 'offset',
      );
    }
  }

  static Future<ActivityRsvp?> _findRsvp(
    Session session,
    int activityId,
    String userIdentifier, {
    Transaction? transaction,
  }) {
    return ActivityRsvp.db.findFirstRow(
      session,
      where: (t) =>
          t.activityId.equals(activityId) &
          t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );
  }

  static Future<int> _attendeeCount(
    Session session,
    int activityId, {
    Transaction? transaction,
  }) {
    return ActivityRsvp.db.count(
      session,
      where: (t) => t.activityId.equals(activityId),
      transaction: transaction,
    );
  }

  static Future<ActivityDetails> _details(
    Session session,
    CampusActivity activity,
    String userIdentifier, {
    Transaction? transaction,
  }) async {
    final activityId = activity.id;
    if (activityId == null) {
      throw StateError('Activity details require a persisted activity.');
    }

    final attendeeCount = await _attendeeCount(
      session,
      activityId,
      transaction: transaction,
    );
    final isAttending =
        await _findRsvp(
          session,
          activityId,
          userIdentifier,
          transaction: transaction,
        ) !=
        null;

    return ActivityDetails(
      activity: activity,
      attendeeCount: attendeeCount,
      isAttending: isAttending,
      isOrganizer: activity.createdByUserIdentifier == userIdentifier,
    );
  }

  static String _currentUserIdentifier(Session session) {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier == null || userIdentifier.isEmpty) {
      throw _error(
        ActivityErrorCode.forbidden,
        'Sign in before using campus activities.',
      );
    }
    return userIdentifier;
  }

  static ActivityException _error(
    ActivityErrorCode code,
    String message, {
    String? field,
  }) {
    return ActivityException(code: code, message: message, field: field);
  }
}

class _CreateActivityValues {
  const _CreateActivityValues({
    required this.title,
    required this.description,
    required this.topic,
    required this.startsAt,
    required this.endsAt,
    required this.location,
    required this.organizerName,
  });

  final String title;
  final String description;
  final String? topic;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String location;
  final String organizerName;
}
