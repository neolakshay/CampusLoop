# CampusLoop server and local development

## Prerequisites

- Flutter 3.47.8 (Dart 3.13.7)
- Serverpod CLI 4.0.4

Install the matching CLI and resolve the workspace packages from the repository
root:

```sh
dart install serverpod_cli@4.0.4
export PATH="${XDG_STATE_HOME:-$HOME/.local/state}/Dart/install/bin:$PATH"
flutter pub get
```

## Local-only passwords

Create `campus_loop_server/config/passwords.yaml` locally. It is gitignored and
must not be committed. Use unique development-only random values, and do not
copy production credentials into this file. The development configuration
requires:

```yaml
development:
  database: "<local random password>"
  serviceSecret: "<local random secret>"
  jwtHmacSha512PrivateKey: "<existing JWT key or new key for a fresh dev DB>"
  jwtRefreshTokenHashPepper: "<existing JWT pepper or new pepper for a fresh dev DB>"
  serverSideSessionKeyHashPepper: "<stable local random secret>"
```

Replace every placeholder; do not use these strings literally. Keep the JWT
key and refresh-token pepper unchanged when preserving existing legacy JWT
sessions. The server-side session pepper must remain stable or username/password
sessions become invalid. Do not add `emailSecretHashPepper` for this app's normal
authentication path; the email identity provider is not configured.

Development uses Serverpod's embedded PostgreSQL under
`.serverpod/development/pgdata`. `serverpod start` applies pending migrations
to that local database. Do not point this run mode at production.

## Start CampusLoop

```sh
cd campus_loop_server
serverpod start
```

This starts the API on `http://localhost:8080` and auto-launches the configured
Flutter companion web app. Username/password registration and login require no
email delivery or OTP. New accounts receive a server-generated Auth Core UUID.
An existing still-authenticated legacy user is asked to set username/password
credentials while retaining that UUID and its activity ownership.

For a physical device, replace `YOUR_HOST_IP` with the development machine's
reachable IP address:

```sh
cd campus_loop_flutter
flutter run --dart-define=SERVER_URL=http://YOUR_HOST_IP:8080/
```

## Checks

```sh
cd campus_loop_server
dart analyze --fatal-infos
dart test
cd ../campus_loop_flutter
flutter analyze
flutter test
flutter build web --base-href /
```

Production requires TLS, real host/database configuration, stable provisioned
JWT and server-side-session secrets, and browser-origin settings. Manual
verified support is the selected recovery policy, but no operator reset/claim
tooling is implemented. Define approved identity verification and single-use
credential delivery before deploying; do not edit account rows ad hoc. There
is no self-service password reset without email.
