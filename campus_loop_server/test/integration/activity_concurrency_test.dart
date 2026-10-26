import 'package:campus_loop_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _organizerId = '650e8400-e29b-41d4-a716-446655440001';
const _firstStudentId = '650e8400-e29b-41d4-a716-446655440002';
const _secondStudentId = '650e8400-e29b-41d4-a716-446655440003';

void main() {
  withServerpod(
    'Given concurrent RSVP attempts',
    (sessionBuilder, endpoints) {
      final organizer = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _organizerId,
          const <Scope>{},
        ),
      );
      final firstStudent = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _firstStudentId,
          const <Scope>{},
        ),
      );
      final secondStudent = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _secondStudentId,
          const <Scope>{},
        ),
      );

      test('only one student can take the last available place', () async {
        final created = await endpoints.activity.createActivity(
          organizer,
          _request(capacity: 2),
        );
        final activityId = created.activity.id!;

        final outcomes = await Future.wait<Object>([
          endpoints.activity
              .joinActivity(firstStudent, activityId)
              .then<Object>(
                (details) => details,
                onError: (Object error) => error,
              ),
          endpoints.activity
              .joinActivity(secondStudent, activityId)
              .then<Object>(
                (details) => details,
                onError: (Object error) => error,
              ),
        ]);

        expect(outcomes.whereType<ActivityDetails>(), hasLength(1));
        final failures = outcomes.whereType<ActivityException>().toList();
        expect(failures, hasLength(1));
        expect(failures.single.code, ActivityErrorCode.full);

        final details = await endpoints.activity.getActivity(
          organizer,
          activityId,
        );
        expect(details?.attendeeCount, 2);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

CreateActivityRequest _request({required int capacity}) {
  final startsAt = DateTime.now().toUtc().add(const Duration(days: 3));
  return CreateActivityRequest(
    kind: ActivityKind.studySession,
    title: 'Concurrent RSVP test',
    description: 'Checks the last place cannot be overbooked.',
    topic: 'Physics',
    startsAt: startsAt,
    endsAt: startsAt.add(const Duration(hours: 1)),
    location: 'Central Library',
    capacity: capacity,
    organizerName: 'Test organizer',
  );
}
