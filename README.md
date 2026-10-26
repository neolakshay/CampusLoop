# CampusLoop

CampusLoop is a Flutter app with a Serverpod backend for campus activities and peer-led study sessions.

## Stack

- Flutter 3.47.8 / Dart 3.13.7
- Serverpod 4.0.4
- PostgreSQL (embedded for local development and tests)

## Run locally

From the repository root, run `flutter pub get`. Create the ignored development secrets file described in [`campus_loop_server/README.md`](campus_loop_server/README.md), then run `cd campus_loop_server && serverpod start`.

## Checks

Backend: `cd campus_loop_server && dart test`

Frontend: `cd campus_loop_flutter && flutter test && flutter build web --base-href /`

See the server and Flutter READMEs for detailed setup and configuration.
