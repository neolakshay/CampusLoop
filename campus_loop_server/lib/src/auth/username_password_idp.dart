import 'dart:convert';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:pool/pool.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_argon2/serverpod_argon2.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Username/password identity provider backed by Serverpod Auth Core users and
/// tokens. Passwords are stored only as Argon2id PHC hashes.
class UsernamePasswordIdp implements IdentityProvider {
  static const String methodName = 'usernamePassword';
  static const int minimumUsernameLength = 3;
  static const int maximumUsernameLength = 32;
  static const int minimumPasswordLength = 12;
  static const int maximumPasswordLength = 128;

  static final RegExp _usernamePattern = RegExp(
    r'^[A-Za-z0-9][A-Za-z0-9._-]{1,30}[A-Za-z0-9]$',
  );
  static final Pool _argon2Pool = Pool(2);
  static final Future<String> _dummyPasswordHash = _hashPassword(
    'campus-loop-unknown-account-dummy-password',
  );

  UsernamePasswordIdp({
    required this.tokenManager,
    required this.authUsers,
    required this.userProfiles,
  }) : _loginByUsernameLimiter = DatabaseRateLimiter(
         RateLimiterConfig(
           domain: 'campus_loop_username_password',
           source: 'failed_login_username_ip',
           maxAttempts: 5,
           timeframe: const Duration(minutes: 15),
         ),
       ),
       _loginByIpLimiter = DatabaseRateLimiter(
         RateLimiterConfig(
           domain: 'campus_loop_username_password',
           source: 'failed_login_ip',
           maxAttempts: 100,
           timeframe: const Duration(minutes: 15),
         ),
       ),
       _registrationByIpLimiter = DatabaseRateLimiter(
         RateLimiterConfig(
           domain: 'campus_loop_username_password',
           source: 'registration_ip',
           maxAttempts: 10,
           timeframe: const Duration(hours: 1),
         ),
       );

  final TokenManager tokenManager;
  final AuthUsers authUsers;
  final UserProfiles userProfiles;
  final DatabaseRateLimiter _loginByUsernameLimiter;
  final DatabaseRateLimiter _loginByIpLimiter;
  final DatabaseRateLimiter _registrationByIpLimiter;

  @override
  String get method => methodName;

  /// Returns whether the caller's current Auth Core session already has
  /// username credentials. Anonymous callers receive false; no user ID is
  /// accepted from the client.
  Future<bool> hasUsernameCredentials(Session session) async {
    final authUserId = _currentAuthUserId(session);
    if (authUserId == null) return false;

    final account = await UsernamePasswordAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    return account != null;
  }

  /// Registers a new user or, for an already-authenticated legacy account,
  /// attaches username credentials to that same server-issued Auth Core ID.
  Future<AuthSuccess> register(
    Session session, {
    required String username,
    required String password,
  }) async {
    final normalizedUsername = _validateUsername(username);
    _validatePassword(password);

    final ipKey = _ipRateLimitKey(session);
    if (!await _registrationByIpLimiter.tryRecordAttempt(session, key: ipKey)) {
      throw _rateLimited();
    }

    // Argon2 is deliberately run outside the database transaction and on a
    // bounded number of worker isolates to avoid blocking the request loop or
    // allocating unbounded memory under concurrent registration attempts.
    final passwordHash = await _hashPassword(password);
    final currentAuthUserId = _currentAuthUserId(session);

    try {
      return await session.db.transaction((transaction) async {
        final existingUsername = await UsernamePasswordAccount.db.findFirstRow(
          session,
          where: (t) => t.usernameKey.equals(normalizedUsername),
          transaction: transaction,
        );
        if (existingUsername != null) throw _usernameTaken();

        late final UuidValue authUserId;
        late final Set<Scope> scopes;
        if (currentAuthUserId == null) {
          final authUser = await authUsers.create(
            session,
            transaction: transaction,
          );
          authUserId = authUser.id;
          scopes = authUser.scopes;
          await userProfiles.createUserProfile(
            session,
            authUserId,
            UserProfileData(userName: username.trim()),
            transaction: transaction,
          );
        } else {
          final authUser = await authUsers.get(
            session,
            authUserId: currentAuthUserId,
            transaction: transaction,
          );
          final existingAccount = await UsernamePasswordAccount.db.findFirstRow(
            session,
            where: (t) => t.authUserId.equals(currentAuthUserId),
            transaction: transaction,
          );
          if (existingAccount != null) {
            throw UsernamePasswordAuthException(
              code: UsernamePasswordAuthErrorCode.credentialsAlreadySet,
              message: 'This account already has a username and password.',
            );
          }

          authUserId = currentAuthUserId;
          scopes = authUser.scopes;
          final profile = await userProfiles.maybeFindUserProfileByUserId(
            session,
            authUserId,
            transaction: transaction,
          );
          if (profile == null) {
            await userProfiles.createUserProfile(
              session,
              authUserId,
              UserProfileData(userName: username.trim()),
              transaction: transaction,
            );
          } else {
            await userProfiles.changeUserName(
              session,
              authUserId,
              username.trim(),
              transaction: transaction,
            );
          }
        }

        await UsernamePasswordAccount.db.insertRow(
          session,
          UsernamePasswordAccount(
            authUserId: authUserId,
            username: username.trim(),
            usernameKey: normalizedUsername,
            passwordHash: passwordHash,
            createdAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );

        return tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: method,
          scopes: scopes,
          transaction: transaction,
        );
      });
    } on DatabaseUniqueViolationException catch (error) {
      if (error.constraintName ==
          'username_password_account_username_key_unique_idx') {
        throw _usernameTaken();
      }
      rethrow;
    }
  }

  /// Authenticates a username/password pair and returns a standard Auth Core
  /// token response. Unknown users and wrong passwords share the same result.
  Future<AuthSuccess> login(
    Session session, {
    required String username,
    required String password,
  }) async {
    final trimmedUsername = username.trim();
    final validUsername = _usernamePattern.hasMatch(trimmedUsername);
    final normalizedUsername = validUsername
        ? trimmedUsername.toLowerCase()
        : '<invalid-username>';
    final usernameRateLimitKey = _usernameRateLimitKey(
      session,
      normalizedUsername,
    );
    final ipRateLimitKey = _ipRateLimitKey(session);
    final usernameAttempts = await _loginByUsernameLimiter.countAttempts(
      session,
      key: usernameRateLimitKey,
    );
    final ipAttempts = await _loginByIpLimiter.countAttempts(
      session,
      key: ipRateLimitKey,
    );
    if (usernameAttempts >= _loginByUsernameLimiter.config.maxAttempts ||
        ipAttempts >= _loginByIpLimiter.config.maxAttempts) {
      throw _rateLimited();
    }

    final account = await UsernamePasswordAccount.db.findFirstRow(
      session,
      where: (t) => t.usernameKey.equals(normalizedUsername),
    );
    final encodedHash = account?.passwordHash ?? await _dummyPasswordHash;
    final passwordWithinMaximum =
        password.runes.length <= maximumPasswordLength;
    final passwordForVerification = passwordWithinMaximum
        ? password
        : 'oversized-invalid-password';
    final passwordMatches = await _verifyPassword(
      passwordForVerification,
      encodedHash,
    );

    if (!validUsername ||
        account == null ||
        !passwordWithinMaximum ||
        !passwordMatches) {
      final usernameAllowed = await _loginByUsernameLimiter.tryRecordAttempt(
        session,
        key: usernameRateLimitKey,
      );
      final ipAllowed = await _loginByIpLimiter.tryRecordAttempt(
        session,
        key: ipRateLimitKey,
      );
      if (!usernameAllowed || !ipAllowed) throw _rateLimited();
      throw _invalidCredentials();
    }

    final currentAuthUserId = _currentAuthUserId(session);
    if (currentAuthUserId != null && currentAuthUserId != account.authUserId) {
      throw UsernamePasswordAuthException(
        code: UsernamePasswordAuthErrorCode.invalidCredentials,
        message: 'Sign out before switching to another account.',
      );
    }

    final authUser = await authUsers.get(
      session,
      authUserId: account.authUserId,
    );
    await _loginByUsernameLimiter.deleteAttempts(
      session,
      key: usernameRateLimitKey,
    );
    return tokenManager.issueToken(
      session,
      authUserId: account.authUserId,
      method: method,
      scopes: authUser.scopes,
    );
  }

  @override
  Future<void> mergeAuthUsers(
    Session session, {
    required UuidValue userToKeepId,
    required UuidValue userToRemoveId,
    required Transaction transaction,
  }) async {
    final removeAccount = await UsernamePasswordAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userToRemoveId),
      transaction: transaction,
    );
    if (removeAccount == null) return;

    final keepAccount = await UsernamePasswordAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userToKeepId),
      transaction: transaction,
    );
    if (keepAccount != null) {
      throw StateError(
        'Cannot merge two accounts that both have username credentials.',
      );
    }

    await UsernamePasswordAccount.db.updateRow(
      session,
      removeAccount.copyWith(authUserId: userToKeepId),
      transaction: transaction,
    );
  }

  String _usernameRateLimitKey(Session session, String username) =>
      _hashKey('${_remoteIpAddress(session)}|$username');

  String _ipRateLimitKey(Session session) =>
      _hashKey(_remoteIpAddress(session));

  String _remoteIpAddress(Session session) =>
      session.request?.connectionInfo.remote.address.toString() ?? 'unknown';

  static String _hashKey(String value) =>
      sha256.convert(utf8.encode(value)).toString();

  static String _validateUsername(String username) {
    final trimmed = username.trim();
    if (!_usernamePattern.hasMatch(trimmed)) {
      throw UsernamePasswordAuthException(
        code: UsernamePasswordAuthErrorCode.validation,
        message:
            'Username must be 3–32 characters, start and end with a letter or number, and use only letters, numbers, dots, underscores, or hyphens.',
        field: 'username',
      );
    }
    return trimmed.toLowerCase();
  }

  static void _validatePassword(String password) {
    final length = password.runes.length;
    if (length < minimumPasswordLength || length > maximumPasswordLength) {
      throw UsernamePasswordAuthException(
        code: UsernamePasswordAuthErrorCode.validation,
        message: 'Password must be between 12 and 128 characters.',
        field: 'password',
      );
    }
    if (password.trim().isEmpty) {
      throw UsernamePasswordAuthException(
        code: UsernamePasswordAuthErrorCode.validation,
        message: 'Password cannot contain only whitespace.',
        field: 'password',
      );
    }
  }

  static UuidValue? _currentAuthUserId(Session session) {
    final identifier = session.authenticated?.userIdentifier;
    if (identifier == null || identifier.isEmpty) return null;
    try {
      return UuidValue.fromString(identifier);
    } on FormatException {
      throw StateError('The authenticated session has an invalid user ID.');
    }
  }

  static UsernamePasswordAuthException _usernameTaken() =>
      UsernamePasswordAuthException(
        code: UsernamePasswordAuthErrorCode.usernameTaken,
        message: 'That username is already taken.',
        field: 'username',
      );

  static UsernamePasswordAuthException _invalidCredentials() =>
      UsernamePasswordAuthException(
        code: UsernamePasswordAuthErrorCode.invalidCredentials,
        message: 'Invalid username or password.',
      );

  static UsernamePasswordAuthException _rateLimited() =>
      UsernamePasswordAuthException(
        code: UsernamePasswordAuthErrorCode.rateLimited,
        message: 'Too many attempts. Wait a while and try again.',
      );

  static Future<String> _hashPassword(String password) =>
      _argon2Pool.withResource(
        () => Isolate.run(() async {
          final argon2 = await Argon2.load();
          return argon2.hash(password, parameters: Argon2Parameters.owasp);
        }),
      );

  static Future<bool> _verifyPassword(String password, String encodedHash) =>
      _argon2Pool.withResource(
        () => Isolate.run(() async {
          try {
            final argon2 = await Argon2.load();
            return argon2.verify(password, encodedHash);
          } on FormatException {
            return false;
          } on Argon2Exception {
            return false;
          }
        }),
      );
}

class UsernamePasswordIdpConfig
    extends IdentityProviderBuilder<UsernamePasswordIdp> {
  const UsernamePasswordIdpConfig();

  @override
  UsernamePasswordIdp build({
    required TokenManager tokenManager,
    required AuthUsers authUsers,
    required UserProfiles userProfiles,
  }) {
    return UsernamePasswordIdp(
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}
