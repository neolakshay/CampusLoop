# CampusLoop backend API contract

**Audience:** Devansh (Flutter client) and any agent integrating the Flutter app.

**Source of truth:** Server definitions under `campus_loop_server/lib/src/activities/` and `.spy.yaml` models beside them. Do not hand-write a REST/JSON client. Serverpod generates the typed client from these definitions.

## Contract verification status

The merged PR #1 contains the activity models/endpoints in the generated client and server protocol. `serverpod generate --force` reported that generated code was up to date, and the generated client methods below were inspected. The activity migration has now been generated locally at `campus_loop_server/migrations/20261025185542138-campus-activities/`; it adds the activity and RSVP tables, relation, and indexes without altering the initial migration. The backend integration suite passed locally against its ephemeral PostgreSQL test database after applying migrations. This migration and the other current working changes are not committed or deployed yet.

## Authentication

`ActivityEndpoint` overrides `requireLogin` to `true`; all activity operations require a signed-in Serverpod user. The server obtains identity from `session.authenticated?.userIdentifier`. No endpoint accepts a user ID or email from the client. The generated Serverpod email provider verifies mailbox access, not student enrollment; no campus-domain enforcement is currently implemented.

## Shared models

| Type | Fields |
|---|---|
| `ActivityKind` | enum `event`, `studySession` |
| `ActivityStatus` | enum `active`, `cancelled` |
| `CampusActivity` | generated `id: int?`; `kind: ActivityKind`; `title: String`; `description: String`; `topic: String?`; `startsAt: DateTime`; `endsAt: DateTime?`; `location: String`; `capacity: int?`; `organizerName: String`; `createdAt: DateTime`; `status: ActivityStatus`; `isDemo: bool`. `createdByUserIdentifier: String?` is server-only and must not appear in the generated client protocol. |
| `CreateActivityRequest` | `kind: ActivityKind`; `title: String`; `description: String`; `topic: String?`; `startsAt: DateTime`; `endsAt: DateTime?`; `location: String`; `capacity: int?`; `organizerName: String`. No owner, RSVP count, status, or demo flag is accepted. |
| `ActivityDetails` | `activity: CampusActivity`; `attendeeCount: int`; `isAttending: bool`; `isOrganizer: bool` |
| `ActivityPlan` | `activity: CampusActivity`; `isOrganizer: bool`; `isAttending: bool`; `joinedAt: DateTime?` |
| `ActivityErrorCode` | `validation`, `notFound`, `full`, `closed`, `forbidden`, `organizerMustCancel` |
| `ActivityException` | `code: ActivityErrorCode`; `message: String`; `field: String?` |

`ActivityRsvp` is an internal table model with a server-only `userIdentifier`; it is not an endpoint result and must not be used as a frontend roster model.

## Endpoint methods

All signatures below are server signatures. `Session` is omitted from the generated Flutter call. Once generated, `ActivityEndpoint` should be available as `client.activity`.

| Server method | Generated-client call pattern (verified in `campus_loop_client/lib/src/protocol/client.dart`) | Behavior |
|---|---|---|
| `Future<List<CampusActivity>> listUpcoming(Session, ActivityKind? kind, int limit, int offset)` | `client.activity.listUpcoming(kind, limit, offset)` | Active activities with start time at/after server UTC now; optional exact kind filter; order start ascending then ID ascending. `limit` 1–30; `offset >= 0`. |
| `Future<ActivityDetails?> getActivity(Session, int activityId)` | `client.activity.getActivity(activityId)` | Returns `null` for an unknown ID. Otherwise returns activity, attendee count, and caller attendance/organizer flags. Can return cancelled/past details if the record exists. |
| `Future<ActivityDetails> createActivity(Session, CreateActivityRequest request)` | `client.activity.createActivity(request)` | Validates request, creates an active non-demo activity, and inserts an organizer RSVP in one transaction. Returned count starts at 1. |
| `Future<ActivityDetails> joinActivity(Session, int activityId)` | `client.activity.joinActivity(activityId)` | Idempotent for an existing RSVP. Locks the activity row and checks status, start time, and capacity before inserting. Capacity includes organizer. |
| `Future<ActivityDetails> leaveActivity(Session, int activityId)` | `client.activity.leaveActivity(activityId)` | Deletes only the caller's RSVP. Repeated leave is a no-op returning current details. Organizer receives `organizerMustCancel`. |
| `Future<ActivityDetails> cancelActivity(Session, int activityId)` | `client.activity.cancelActivity(activityId)` | Organizer-only soft cancellation. Repeated owner cancellation is idempotent; attendee rows remain; active feed excludes cancelled activities. |
| `Future<List<ActivityPlan>> listMyPlans(Session, int limit, int offset)` | `client.activity.listMyPlans(limit, offset)` | Future activities owned by or RSVP'd by caller, deduplicated and ordered start ascending then ID; cancelled future plans remain visible. Page size 1–30, offset nonnegative. |

## Validation and edge cases

- Trim required strings. Title 3–80 chars; description 10–500; organizer name 2–40; location 2–100; topic max 40.
- Study sessions require a nonblank topic; event topic is optional and blank event topic normalizes to null.
- `startsAt` must be future according to server UTC time. Optional `endsAt` must be later than `startsAt`. Serverpod serializes `DateTime` in UTC; convert to local time only for display.
- `capacity` is null for unlimited or 2–100 inclusive. It counts the organizer; capacity 1 is invalid.
- Expected validation uses `ActivityException(code: validation, field: ...)`. `full`, `closed`, `forbidden`, and `organizerMustCancel` are typed domain errors. Missing `getActivity` returns null; mutations on missing activity throw `notFound`. Anonymous calls are rejected by Serverpod auth before endpoint logic.
- A concurrent last-seat race is covered by a backend regression test using two authenticated callers and a row lock. The full backend test suite, including this test, passed locally against the ephemeral PostgreSQL test database.
- The declared unique RSVP index and table relation are in the generated local migration. The migration is not committed and has not been applied to any shared or production database.

## Current integration blockers / open questions

1. The generated protocol and migration are locally consistent and the backend tests pass. The migration still needs to be committed before CI can use it; no shared/production database has been modified.
2. CI should retain `serverpod generate` before integration tests and verify generated artifacts are checked in. Analyze and Format should cover the Flutter package as well as the backend.
3. Local/deployed browser cookie origin settings and campus membership/domain rules remain unresolved. This API verifies sign-in, not student enrollment.
4. The `listMyPlans` implementation currently loads the caller's owned activities and RSVP rows before sorting/paging. At current hackathon scope this was left unchanged; revisit only if expected account activity volume warrants a bounded query design.
