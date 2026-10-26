/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:campus_loop_server/src/generated/activities/models/activity_kind.dart'
    as _iu1qkyfe;
import 'package:campus_loop_server/src/generated/activities/models/create_activity_request.dart'
    as _iftmrj3u;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../activities/activity_endpoint.dart' as _i8zt5649;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../auth/username_password_endpoint.dart' as _ilxmqtc9;
import '../greetings/greeting_endpoint.dart' as _il624ik7;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'activity': _i8zt5649.ActivityEndpoint()
        ..initialize(
          server,
          'activity',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'usernamePassword': _ilxmqtc9.UsernamePasswordEndpoint()
        ..initialize(
          server,
          'usernamePassword',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['activity'] = _is.EndpointConnector(
      name: 'activity',
      endpoint: endpoints['activity']!,
      methodConnectors: {
        'listUpcoming': _is.MethodConnector(
          name: 'listUpcoming',
          params: {
            'kind': _is.ParameterDescription(
              name: 'kind',
              type: _is.getType<_iu1qkyfe.ActivityKind?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i8zt5649.ActivityEndpoint)
                  .listUpcoming(
                    session,
                    params['kind'],
                    params['limit'],
                    params['offset'],
                  ),
        ),
        'getActivity': _is.MethodConnector(
          name: 'getActivity',
          params: {
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i8zt5649.ActivityEndpoint)
                  .getActivity(
                    session,
                    params['activityId'],
                  ),
        ),
        'createActivity': _is.MethodConnector(
          name: 'createActivity',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iftmrj3u.CreateActivityRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i8zt5649.ActivityEndpoint)
                  .createActivity(
                    session,
                    params['request'],
                  ),
        ),
        'joinActivity': _is.MethodConnector(
          name: 'joinActivity',
          params: {
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i8zt5649.ActivityEndpoint)
                  .joinActivity(
                    session,
                    params['activityId'],
                  ),
        ),
        'leaveActivity': _is.MethodConnector(
          name: 'leaveActivity',
          params: {
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i8zt5649.ActivityEndpoint)
                  .leaveActivity(
                    session,
                    params['activityId'],
                  ),
        ),
        'cancelActivity': _is.MethodConnector(
          name: 'cancelActivity',
          params: {
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i8zt5649.ActivityEndpoint)
                  .cancelActivity(
                    session,
                    params['activityId'],
                  ),
        ),
        'listMyPlans': _is.MethodConnector(
          name: 'listMyPlans',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i8zt5649.ActivityEndpoint)
                  .listMyPlans(
                    session,
                    params['limit'],
                    params['offset'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['usernamePassword'] = _is.EndpointConnector(
      name: 'usernamePassword',
      endpoint: endpoints['usernamePassword']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'username': _is.ParameterDescription(
              name: 'username',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['usernamePassword']
                          as _ilxmqtc9.UsernamePasswordEndpoint)
                      .register(
                        session,
                        params['username'],
                        params['password'],
                      ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'username': _is.ParameterDescription(
              name: 'username',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['usernamePassword']
                          as _ilxmqtc9.UsernamePasswordEndpoint)
                      .login(
                        session,
                        params['username'],
                        params['password'],
                      ),
        ),
        'hasUsernameCredentials': _is.MethodConnector(
          name: 'hasUsernameCredentials',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['usernamePassword']
                          as _ilxmqtc9.UsernamePasswordEndpoint)
                      .hasUsernameCredentials(session),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
  }
}
