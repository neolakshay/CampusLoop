import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import 'username_password_idp.dart';

/// Public username/password entry points. Identity is always obtained from the
/// Serverpod session; callers cannot choose an Auth Core user ID.
class UsernamePasswordEndpoint extends Endpoint {
  UsernamePasswordIdp get _idp =>
      AuthServices.getIdentityProvider<UsernamePasswordIdp>();

  Future<AuthSuccess> register(
    Session session,
    String username,
    String password,
  ) {
    return _idp.register(session, username: username, password: password);
  }

  Future<AuthSuccess> login(
    Session session,
    String username,
    String password,
  ) {
    return _idp.login(session, username: username, password: password);
  }

  /// Checks the current session only. An anonymous caller receives false.
  Future<bool> hasUsernameCredentials(Session session) {
    return _idp.hasUsernameCredentials(session);
  }
}
