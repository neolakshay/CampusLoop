import 'package:serverpod/serverpod.dart';
import 'package:campus_loop_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _organizerId = '550e8400-e29b-41d4-a716-446655440001';
const _studentId = '550e8400-e29b-41d4-a716-446655440002';
const _otherStudentId = '550e8400-e29b-41d4-a716-446655440003';

void main() {
  withServerpod('Given the Activity endpoint', (sessionBuilder, endpoints) {
    final organizer = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        _organizerId,
        const <Scope>{},
      ),
    );
    final student = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        _studentId,
        const <Scope>{},
      ),
    );
    final otherStudent = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        _otherStudentId,
        const <Scope>{},
      ),
    );

    test('requires sign-in for activity methods', () async {
      final anonymous = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );

      await expectLater(
        endpoints.activity.listUpcoming(anonymous, null, 20, 0),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('creates an activity and includes organizer in RSVP count', () async {
      final details = await endpoints.activity.createActivity(
        organizer,
        _request(kind: ActivityKind.studySession, topic: 'Calculus I'),
      );

      expect(details.activity.id, isNotNull);
      expect(details.activity.kind, ActivityKind.studySession);
      expect(details.activity.topic, 'Calculus I');
      expect(details.activity.status, ActivityStatus.active);
      expect(details.activity.isDemo, isFalse);
      expect(details.attendeeCount, 1);
      expect(details.isOrganizer, isTrue);
      expect(details.isAttending, isTrue);
    });

    test('filters and paginates upcoming activities in stable order', () async {
      final later = _request(
        title: 'Later event',
        startsAt: DateTime.now().toUtc().add(const Duration(days: 5)),
      );
      final sooner = _request(
        kind: ActivityKind.studySession,
        title: 'Sooner study group',
        topic: 'Physics',
        startsAt: DateTime.now().toUtc().add(const Duration(days: 2)),
      );
      await endpoints.activity.createActivity(organizer, later);
      await endpoints.activity.createActivity(organizer, sooner);

      final all = await endpoints.activity.listUpcoming(organizer, null, 1, 0);
      final studySessions = await endpoints.activity.listUpcoming(
        organizer,
        ActivityKind.studySession,
        20,
        0,
      );

      expect(all, hasLength(1));
      expect(all.single.title, 'Sooner study group');
      expect(studySessions, hasLength(1));
      expect(studySessions.single.kind, ActivityKind.studySession);
      expect(
        await endpoints.activity.listUpcoming(organizer, null, 20, 20),
        isEmpty,
      );
    });

    test(
      'makes joins idempotent and enforces capacity including organizer',
      () async {
        final created = await endpoints.activity.createActivity(
          organizer,
          _request(capacity: 2),
        );
        final activityId = created.activity.id!;

        final firstJoin = await endpoints.activity.joinActivity(
          student,
          activityId,
        );
        final repeatedJoin = await endpoints.activity.joinActivity(
          student,
          activityId,
        );
        expect(firstJoin.attendeeCount, 2);
        expect(repeatedJoin.attendeeCount, 2);
        expect(repeatedJoin.isAttending, isTrue);

        await expectLater(
          endpoints.activity.joinActivity(otherStudent, activityId),
          throwsA(
            isA<ActivityException>().having(
              (error) => error.code,
              'code',
              ActivityErrorCode.full,
            ),
          ),
        );

        final afterLeave = await endpoints.activity.leaveActivity(
          student,
          activityId,
        );
        expect(afterLeave.attendeeCount, 1);
        expect(afterLeave.isAttending, isFalse);

        final nextStudent = await endpoints.activity.joinActivity(
          otherStudent,
          activityId,
        );
        expect(nextStudent.attendeeCount, 2);
      },
    );

    test('organizer cannot leave and only organizer can cancel', () async {
      final created = await endpoints.activity.createActivity(
        organizer,
        _request(),
      );
      final activityId = created.activity.id!;

      await expectLater(
        endpoints.activity.leaveActivity(organizer, activityId),
        throwsA(
          isA<ActivityException>().having(
            (error) => error.code,
            'code',
            ActivityErrorCode.organizerMustCancel,
          ),
        ),
      );
      await expectLater(
        endpoints.activity.cancelActivity(student, activityId),
        throwsA(
          isA<ActivityException>().having(
            (error) => error.code,
            'code',
            ActivityErrorCode.forbidden,
          ),
        ),
      );

      final cancelled = await endpoints.activity.cancelActivity(
        organizer,
        activityId,
      );
      expect(cancelled.activity.status, ActivityStatus.cancelled);
      expect(
        await endpoints.activity.cancelActivity(organizer, activityId),
        predicate<ActivityDetails>(
          (details) => details.activity.status == ActivityStatus.cancelled,
        ),
      );
      expect(
        await endpoints.activity.listUpcoming(organizer, null, 20, 0),
        isEmpty,
      );
      await expectLater(
        endpoints.activity.joinActivity(student, activityId),
        throwsA(
          isA<ActivityException>().having(
            (error) => error.code,
            'code',
            ActivityErrorCode.closed,
          ),
        ),
      );

      final plans = await endpoints.activity.listMyPlans(organizer, 20, 0);
      expect(plans, hasLength(1));
      expect(plans.single.activity.status, ActivityStatus.cancelled);
      expect(plans.single.isOrganizer, isTrue);
    });

    test('rejects invalid fields and invalid pagination', () async {
      await expectLater(
        endpoints.activity.createActivity(
          organizer,
          _request(
            kind: ActivityKind.studySession,
            topic: '  ',
          ),
        ),
        throwsA(
          isA<ActivityException>().having(
            (error) => error.field,
            'field',
            'topic',
          ),
        ),
      );
      await expectLater(
        endpoints.activity.listUpcoming(organizer, null, 31, 0),
        throwsA(isA<ActivityException>()),
      );
      await expectLater(
        endpoints.activity.listMyPlans(organizer, 20, -1),
        throwsA(isA<ActivityException>()),
      );
    });

    test('returns null for an activity id that does not exist', () async {
      expect(await endpoints.activity.getActivity(organizer, 999999), isNull);
    });

    test('lists organizer and participant plans without duplicates', () async {
      final created = await endpoints.activity.createActivity(
        organizer,
        _request(),
      );
      final activityId = created.activity.id!;
      await endpoints.activity.joinActivity(student, activityId);

      final organizerPlans = await endpoints.activity.listMyPlans(
        organizer,
        20,
        0,
      );
      final studentPlans = await endpoints.activity.listMyPlans(student, 20, 0);

      expect(organizerPlans, hasLength(1));
      expect(organizerPlans.single.isOrganizer, isTrue);
      expect(organizerPlans.single.isAttending, isTrue);
      expect(studentPlans, hasLength(1));
      expect(studentPlans.single.isOrganizer, isFalse);
      expect(studentPlans.single.isAttending, isTrue);
      expect(studentPlans.single.joinedAt, isNotNull);
    });
  });
}

CreateActivityRequest _request({
  ActivityKind kind = ActivityKind.event,
  String title = 'Campus meetup',
  String description = 'A small meetup for students on campus.',
  String? topic = 'Campus life',
  int? capacity,
  DateTime? startsAt,
}) {
  final start = startsAt ?? DateTime.now().toUtc().add(const Duration(days: 3));
  return CreateActivityRequest(
    kind: kind,
    title: title,
    description: description,
    topic: topic,
    startsAt: start,
    endsAt: start.add(const Duration(hours: 1)),
    location: 'Central Library',
    capacity: capacity,
    organizerName: 'Campus host',
  );
}
