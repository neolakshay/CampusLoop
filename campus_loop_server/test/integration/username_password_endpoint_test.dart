import 'dart:math';

import 'package:campus_loop_server/src/generated/protocol.dart';
import 'package:campus_loop_server/src/auth/username_password_idp.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  setUpAll(() {
    AuthServices.set(
      tokenManagerBuilders: [
        ServerSideSessionsConfig(
          sessionKeyHashPepper: _randomTestSecret(),
          defaultSessionLifetime: const Duration(days: 30),
          defaultSessionInactivityTimeout: const Duration(days: 30),
        ),
        JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(SecretKey(_randomTestSecret())),
          refreshTokenHashPepper: _randomTestSecret(),
        ),
      ],
      identityProviderBuilders: [UsernamePasswordIdpConfig()],
    );
  });

  withServerpod(
    'Given the UsernamePassword endpoint',
    (sessionBuilder, endpoints) {
      test(
        'registers without email and stores only an Argon2id hash',
        () async {
          const password = 'Maple-Trail-Password-42';
          final result = await endpoints.usernamePassword.register(
            sessionBuilder,
            'WillowStudent',
            password,
          );
          expect(result.authStrategy, 'session');
          final session = sessionBuilder.build();

          final account = await UsernamePasswordAccount.db.findFirstRow(
            session,
            where: (t) => t.authUserId.equals(result.authUserId),
          );
          expect(account, isNotNull);
          expect(account!.username, 'WillowStudent');
          expect(account.usernameKey, 'willowstudent');
          expect(account.passwordHash, isNot(password));
          expect(account.passwordHash, startsWith(r'$argon2id$'));

          final profile = await AuthServices.instance.userProfiles
              .maybeFindUserProfileByUserId(session, result.authUserId);
          expect(profile?.userName, 'WillowStudent');
          expect(profile?.email, isNull);

          final authenticated = await AuthServices.instance
              .authenticationHandler(
                session,
                result.token,
              );
          expect(authenticated?.userIdentifier, result.authUserId.toString());
        },
      );

      test(
        'login is case insensitive and returns a persistent session',
        () async {
          const username = 'MapleUser';
          const password = 'Maple-Trail-Password-43';
          final registered = await endpoints.usernamePassword.register(
            sessionBuilder,
            username,
            password,
          );

          final loggedIn = await endpoints.usernamePassword.login(
            sessionBuilder,
            'mapleuser',
            password,
          );
          expect(loggedIn.authUserId, registered.authUserId);
          expect(loggedIn.authStrategy, 'session');
          expect(loggedIn.token, isNotEmpty);
          expect(loggedIn.refreshToken, isNull);
        },
      );

      test(
        'wrong and unknown credentials use the same generic error',
        () async {
          await endpoints.usernamePassword.register(
            sessionBuilder,
            'KnownUser',
            'Known-Account-Password-44',
          );

          final wrongPassword = await _captureAuthError(
            () => endpoints.usernamePassword.login(
              sessionBuilder,
              'KnownUser',
              'Incorrect-Password-45',
            ),
          );
          final unknownUsername = await _captureAuthError(
            () => endpoints.usernamePassword.login(
              sessionBuilder,
              'UnknownUser',
              'Incorrect-Password-45',
            ),
          );

          expect(
            wrongPassword.code,
            UsernamePasswordAuthErrorCode.invalidCredentials,
          );
          expect(
            unknownUsername.code,
            UsernamePasswordAuthErrorCode.invalidCredentials,
          );
          expect(wrongPassword.message, 'Invalid username or password.');
          expect(unknownUsername.message, wrongPassword.message);
        },
      );

      test('rejects duplicate usernames case insensitively', () async {
        await endpoints.usernamePassword.register(
          sessionBuilder,
          'CampusName',
          'Campus-Account-Password-46',
        );

        final duplicate = await _captureAuthError(
          () => endpoints.usernamePassword.register(
            sessionBuilder,
            'campusname',
            'Another-Account-Password-47',
          ),
        );
        expect(duplicate.code, UsernamePasswordAuthErrorCode.usernameTaken);
      });

      test('validates username and password on the server', () async {
        final invalidUsername = await _captureAuthError(
          () => endpoints.usernamePassword.register(
            sessionBuilder,
            'ab',
            'Valid-Account-Password-48',
          ),
        );
        expect(invalidUsername.code, UsernamePasswordAuthErrorCode.validation);
        expect(invalidUsername.field, 'username');

        final invalidPassword = await _captureAuthError(
          () => endpoints.usernamePassword.register(
            sessionBuilder,
            'ValidName',
            'short',
          ),
        );
        expect(invalidPassword.code, UsernamePasswordAuthErrorCode.validation);
        expect(invalidPassword.field, 'password');
      });

      test('rate limits repeated failed logins', () async {
        await endpoints.usernamePassword.register(
          sessionBuilder,
          'RateLimitedUser',
          'Rate-Limit-Account-Password-49',
        );

        for (var attempt = 0; attempt < 5; attempt++) {
          final error = await _captureAuthError(
            () => endpoints.usernamePassword.login(
              sessionBuilder,
              'RateLimitedUser',
              'Wrong-Account-Password-50',
            ),
          );
          expect(error.code, UsernamePasswordAuthErrorCode.invalidCredentials);
        }

        final rateLimited = await _captureAuthError(
          () => endpoints.usernamePassword.login(
            sessionBuilder,
            'RateLimitedUser',
            'Wrong-Account-Password-50',
          ),
        );
        expect(rateLimited.code, UsernamePasswordAuthErrorCode.rateLimited);
      });

      test(
        'legacy authenticated user can claim credentials without changing identity',
        () async {
          final setupSession = sessionBuilder.build();
          final legacyUser = await AuthServices.instance.authUsers.create(
            setupSession,
          );
          await AuthServices.instance.userProfiles.createUserProfile(
            setupSession,
            legacyUser.id,
            UserProfileData(fullName: 'Legacy account'),
          );
          final legacySession = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              legacyUser.id.toString(),
              legacyUser.scopes,
            ),
          );

          final activity = await endpoints.activity.createActivity(
            legacySession,
            _activityRequest('Legacy-owned activity'),
          );
          expect(
            await endpoints.usernamePassword.hasUsernameCredentials(
              legacySession,
            ),
            isFalse,
          );

          final claimed = await endpoints.usernamePassword.register(
            legacySession,
            'LegacyUser',
            'Legacy-Account-Password-51',
          );
          expect(claimed.authUserId, legacyUser.id);
          expect(
            await endpoints.usernamePassword.hasUsernameCredentials(
              legacySession,
            ),
            isTrue,
          );

          final loggedIn = await endpoints.usernamePassword.login(
            sessionBuilder,
            'legacyuser',
            'Legacy-Account-Password-51',
          );
          expect(loggedIn.authUserId, legacyUser.id);

          final plans = await endpoints.activity.listMyPlans(
            legacySession,
            30,
            0,
          );
          expect(
            plans.map((plan) => plan.activity.id),
            contains(activity.activity.id),
          );
        },
      );

      test(
        'logout immediately revokes the server-side session',
        () async {
          final auth = await endpoints.usernamePassword.register(
            sessionBuilder,
            'LogoutUser',
            'Logout-Account-Password-52',
          );
          final session = sessionBuilder.build();
          expect(
            (await AuthServices.instance.authenticationHandler(
              session,
              auth.token,
            ))?.userIdentifier,
            auth.authUserId.toString(),
          );

          final authentication = await AuthServices.instance
              .authenticationHandler(
                session,
                auth.token,
              );
          expect(authentication, isNotNull);
          expect(auth.authStrategy, 'session');

          // This is the core operation used by signOutDevice.
          await AuthServices.instance.tokenManager.revokeToken(
            session,
            tokenId: authentication!.authId,
          );

          expect(
            await AuthServices.instance.authenticationHandler(
              session,
              auth.token,
            ),
            isNull,
          );
        },
      );

      test(
        'legacy email-method JWT sessions remain valid during migration',
        () async {
          final session = sessionBuilder.build();
          final legacyUser = await AuthServices.instance.authUsers.create(
            session,
          );
          final legacySession =
              await AuthServices.getTokenManager<JwtTokenManager>().createToken(
                session,
                authUserId: legacyUser.id,
                method: 'email',
                scopes: legacyUser.scopes,
              );

          final authenticated = await AuthServices.instance
              .authenticationHandler(
                session,
                legacySession.token,
              );
          expect(authenticated?.userIdentifier, legacyUser.id.toString());

          final refreshed = await endpoints.jwtRefresh.refreshAccessToken(
            sessionBuilder,
            refreshToken: legacySession.refreshToken,
          );
          expect(refreshed.authUserId, legacyUser.id);
        },
      );

      test('authenticated user cannot impersonate an organizer', () async {
        final organizer = await endpoints.usernamePassword.register(
          sessionBuilder,
          'OrganizerUser',
          'Organizer-Account-Password-53',
        );
        final attendee = await endpoints.usernamePassword.register(
          sessionBuilder,
          'AttendeeUser',
          'Attendee-Account-Password-54',
        );
        final organizerSession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            organizer.authUserId.toString(),
            const <Scope>{},
          ),
        );
        final attendeeSession = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            attendee.authUserId.toString(),
            const <Scope>{},
          ),
        );
        final activity = await endpoints.activity.createActivity(
          organizerSession,
          _activityRequest('Organizer protected activity'),
        );

        final error = await _captureActivityError(
          () => endpoints.activity.cancelActivity(
            attendeeSession,
            activity.activity.id!,
          ),
        );
        expect(error.code, ActivityErrorCode.forbidden);

        final attendeePlans = await endpoints.activity.listMyPlans(
          attendeeSession,
          30,
          0,
        );
        expect(attendeePlans, isEmpty);
      });
    },
  );
}

String _randomTestSecret() {
  final random = Random.secure();
  return List<int>.generate(
    32,
    (_) => random.nextInt(256),
  ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

CreateActivityRequest _activityRequest(String title) {
  final startsAt = DateTime.now().toUtc().add(const Duration(days: 3));
  return CreateActivityRequest(
    kind: ActivityKind.studySession,
    title: title,
    description: 'A test activity created through the username identity.',
    topic: 'Physics',
    startsAt: startsAt,
    endsAt: startsAt.add(const Duration(hours: 1)),
    location: 'Central Library',
    capacity: 10,
    organizerName: 'Campus host',
  );
}

Future<UsernamePasswordAuthException> _captureAuthError(
  Future<Object?> Function() request,
) async {
  try {
    await request();
  } on UsernamePasswordAuthException catch (error) {
    return error;
  }
  throw StateError('Expected a username/password authentication exception.');
}

Future<ActivityException> _captureActivityError(
  Future<Object?> Function() request,
) async {
  try {
    await request();
  } on ActivityException catch (error) {
    return error;
  }
  throw StateError('Expected an activity authorization exception.');
}
