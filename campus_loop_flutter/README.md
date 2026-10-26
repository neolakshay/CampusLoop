# CampusLoop Flutter client

CampusLoop uses username/password authentication through the generated
Serverpod client. Email, email verification, OTP, and email delivery are not
required for registration or login.

For local credentials and Serverpod startup, see
[`../campus_loop_server/README.md`](../campus_loop_server/README.md).

From the repository root, resolve packages:

```sh
flutter pub get
```

For normal local development, start from `campus_loop_server` with
`serverpod start`; it launches the configured Flutter web companion. To run
Flutter separately, keep the API server running and use:

```sh
cd campus_loop_flutter
flutter run -d chrome --dart-define=SERVER_URL=http://localhost:8080/
```

For a physical device, replace `localhost` with the development machine's
reachable IP. Existing signed-in accounts without username credentials are
prompted to set them using their current session. Users with expired legacy
sessions need the approved account-recovery path before production rollout.

Run Flutter checks/build with:

```sh
flutter analyze
flutter test
flutter build web --base-href /
```
