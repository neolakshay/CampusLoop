import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:campus_loop_flutter/screens/create_activity_screen.dart';
import 'package:campus_loop_flutter/screens/username_password_form.dart';
import 'package:campus_loop_flutter/state/activity_state.dart';
import 'package:campus_loop_flutter/widgets/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

void main() {
  testWidgets('activity card does not guess attendee count', (tester) async {
    final activity = _activity();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(
            activity: activity,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Capacity up to 10 attendees'), findsOneWidget);
    expect(find.text('1 / 10 attending (9 spots left)'), findsNothing);
  });

  testWidgets('activity card shows the backend attendee count', (tester) async {
    final activity = _activity();
    final details = ActivityDetails(
      activity: activity,
      attendeeCount: 4,
      isAttending: false,
      isOrganizer: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(
            activity: activity,
            cachedDetails: details,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('4 / 10 attending (6 spots left)'), findsOneWidget);
  });

  testWidgets('study session form requires a topic before submitting', (
    tester,
  ) async {
    final state = ActivityState();
    addTearDown(state.dispose);

    await tester.pumpWidget(
      MaterialApp(home: CreateActivityScreen(state: state)),
    );
    await tester.tap(find.text('Publish Study Session'));
    await tester.pumpAndSettle();

    expect(
      find.text('A study session needs a course or topic'),
      findsOneWidget,
    );
  });

  testWidgets('username auth offers login and registration without email', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UsernamePasswordForm(
          setupExistingAccount: false,
          isDark: false,
          onAuthenticated: () async {},
        ),
      ),
    );

    expect(find.text('Sign in'), findsNWidgets(2));
    expect(find.text('Email'), findsNothing);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.text('New to CampusLoop? Create an account'));
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Confirm password'), findsOneWidget);
  });

  testWidgets('username registration validates password confirmation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UsernamePasswordForm(
          setupExistingAccount: false,
          isDark: false,
          onAuthenticated: () async {},
        ),
      ),
    );
    await tester.tap(find.text('New to CampusLoop? Create an account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'MapleUser');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Maple-Trail-Password-42',
    );
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Maple-Trail-Password-43',
    );
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  test(
    'auth session manager restores and clears a persisted session',
    () async {
      final storage = _MemoryAuthStorage();
      final firstManager = FlutterAuthSessionManager(storage: storage);
      final auth = AuthSuccess(
        authStrategy: 'session',
        token: 'test-server-session-token',
        tokenExpiresAt: DateTime.now().toUtc().add(const Duration(days: 30)),
        authUserId: UuidValue.fromString(
          '650e8400-e29b-41d4-a716-446655440011',
        ),
        scopeNames: const <String>{},
      );

      await firstManager.updateSignedInUser(auth);
      expect(firstManager.isAuthenticated, isTrue);

      final restoredManager = FlutterAuthSessionManager(storage: storage);
      await restoredManager.restore();
      expect(restoredManager.isAuthenticated, isTrue);
      expect(restoredManager.authInfo?.authUserId, auth.authUserId);
      expect(restoredManager.authInfo?.authStrategy, 'session');

      await restoredManager.updateSignedInUser(null);
      final afterLogout = FlutterAuthSessionManager(storage: storage);
      await afterLogout.restore();
      expect(afterLogout.isAuthenticated, isFalse);
    },
  );
}

CampusActivity _activity() {
  final startsAt = DateTime.now().toUtc().add(const Duration(days: 3));
  return CampusActivity(
    kind: ActivityKind.event,
    title: 'Campus event',
    description: 'A campus gathering for students.',
    startsAt: startsAt,
    endsAt: startsAt.add(const Duration(hours: 1)),
    location: 'Central Library',
    capacity: 10,
    organizerName: 'Student host',
  );
}

class _MemoryAuthStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _authInfo;

  @override
  Future<AuthSuccess?> get() async => _authInfo;

  @override
  Future<void> set(AuthSuccess? data) async {
    _authInfo = data;
  }
}
