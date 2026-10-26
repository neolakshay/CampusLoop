# CampusLoop backend API contract

**Audience:** Devansh (Flutter client) and any agent integrating the Flutter app.

**Source of truth:** Server definitions under `campus_loop_server/lib/src/activities/` and `.spy.yaml` models beside them. Do not hand-write a REST/JSON client. Serverpod generates the typed client from these definitions.

## Contract verification status

The activity protocol and migrations are generated from the Serverpod 4.0.4 source models. The activity migration adds the activity and RSVP tables, relation, and indexes. The username/password authentication migration adds only the username credential table and its indexes/relation; it does not remove or rewrite existing auth, activity, or RSVP tables. Backend tests run against Serverpod's ephemeral PostgreSQL test database. No migration has been applied to a production database.

## Authentication

Registration and login use the custom `UsernamePasswordIdp`, integrated with Serverpod Auth Core 4.0.4. The public generated client calls are `client.usernamePassword.register(username, password)` and `client.usernamePassword.login(username, password)`. Both return Auth Core `AuthSuccess`; the Flutter app persists it through `client.auth.updateSignedInUser`, and the Auth Core Flutter session manager restores it on app startup. New username/password sessions use Auth Core's database-backed server-side session manager (30-day absolute and inactivity expiry); `client.auth.signOutDevice()` revokes that session immediately. JWT remains a secondary token manager only to validate and refresh existing legacy email-authenticated sessions during migration.

Auth Core generates the stable UUID user identifier. Username credentials are stored in the server-only `username_password_account` table; passwords are stored as Argon2id PHC hashes with random salts. Username keys are normalized to lowercase and protected by a database unique index. The server validates usernames (3–32 ASCII letters, digits, dots, underscores, or hyphens) and passwords (12–128 characters). Unknown usernames and wrong passwords return the same generic login error. Login attempts are limited to 5 failed attempts per username/IP per 15 minutes and 100 failed attempts per IP per 15 minutes; registration is limited to 10 attempts per IP per hour. These limits use the existing database-backed Serverpod rate-limiter table and hash the username/IP rate-limit keys.

The limiter uses the direct peer address from `session.request.connectionInfo.remote.address`. Behind a reverse proxy, configure trusted client-IP handling or an edge rate limit; otherwise requests may share the proxy's bucket. Serverpod records attempt/IP metadata in its database-backed table, and this provider does not schedule expired-row cleanup. Monitor table growth and configure retention cleanup before production.

`ActivityEndpoint` still requires authentication. Activity ownership and RSVP identity continue to come from `session.authenticated?.userIdentifier`; no activity endpoint accepts an owner/user ID from the client.

The email identity-provider endpoint and email sign-in UI are removed from the normal app/API path. The `serverpod_auth_idp_server` package remains only for the shared rate limiter and existing module schema; the email provider is not configured. Existing email-account and Auth Core session tables are intentionally preserved. A still-authenticated legacy account can claim username/password credentials through the authenticated registration flow, preserving its Auth Core UUID and activity ownership. A legacy account whose session has expired cannot be converted through the app. Manual verified support is the selected recovery policy, but no operator reset/claim tooling exists. The draft procedure and required owner decisions are in [`username-password-support-runbook.md`](username-password-support-runbook.md); do not modify auth rows ad hoc. The production account count and active sessions were not inspected, so do not deploy the auth migration until that procedure and the legacy-user population are reviewed.

The server additionally requires a stable `serverSideSessionKeyHashPepper` in each run mode's secret store. Changing it invalidates those server-side sessions. Preserve existing JWT signing/refresh secrets during the transition so active legacy JWT sessions can continue. Password reset is not available in the app; until an approved support recovery procedure exists, a forgotten password requires manual account-level support.

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

`UsernamePasswordAccount` is also server-only. The generated client does not expose its password hash or credential records.

## Endpoint methods

All signatures below are server signatures. `Session` is omitted from the generated Flutter call. Once generated, `ActivityEndpoint` should be available as `client.activity`.

Authentication calls are generated as `client.usernamePassword.register(username, password)`, `client.usernamePassword.login(username, password)`, and `client.usernamePassword.hasUsernameCredentials()`. The status method only inspects the caller's current session and accepts no user identifier.

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

1. The username migration is additive and generated locally. The production account/session count was not inspected, and no production migration or auth configuration was changed.
2. Configure `serverSideSessionKeyHashPepper` in each environment's secret store. Keep it stable for active server-side sessions and preserve the existing JWT signing/refresh secrets until legacy JWT sessions have expired or been migrated.
3. Before production rollout, decide how legacy users with expired email-auth sessions will recover. Active legacy sessions can claim username/password credentials without email; existing email-account records are retained.
4. Production TLS, browser origins, database hosts/credentials, and campus membership policy remain to be configured. Username registration does not verify student enrollment.
5. The `listMyPlans` implementation currently loads the caller's owned activities and RSVP rows before sorting/paging; it was left unchanged at current hackathon scope.
