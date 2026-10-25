/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:campus_loop_server/src/generated/activities/models/activity_plan.dart'
    as _i1ksolij;
import 'package:campus_loop_server/src/generated/activities/models/campus_activity.dart'
    as _imev5sfu;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'activities/models/activity_details.dart' as _iom5v97i;
import 'activities/models/activity_error_code.dart' as _idjzi6az;
import 'activities/models/activity_exception.dart' as _ixtu7ny3;
import 'activities/models/activity_kind.dart' as _ikhhbudg;
import 'activities/models/activity_plan.dart' as _i78jcvve;
import 'activities/models/activity_rsvp.dart' as _ikc54jsx;
import 'activities/models/activity_status.dart' as _ievczi9g;
import 'activities/models/campus_activity.dart' as _iz8d91lk;
import 'activities/models/create_activity_request.dart' as _iv4m3ter;
import 'greetings/greeting.dart' as _izw8z7ou;
export 'activities/models/activity_details.dart';
export 'activities/models/activity_error_code.dart';
export 'activities/models/activity_exception.dart';
export 'activities/models/activity_kind.dart';
export 'activities/models/activity_plan.dart';
export 'activities/models/activity_rsvp.dart';
export 'activities/models/activity_status.dart';
export 'activities/models/campus_activity.dart';
export 'activities/models/create_activity_request.dart';
export 'greetings/greeting.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'activity_rsvp',
      dartName: 'ActivityRsvp',
      schema: 'public',
      module: 'campus_loop',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'joinedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'activity_rsvp_fk_0',
          columns: ['activityId'],
          referenceTable: 'campus_activity',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'activity_rsvp_activity_user_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'activityId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'activity_rsvp_user_joined_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'joinedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'campus_activity',
      dartName: 'CampusActivity',
      schema: 'public',
      module: 'campus_loop',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ActivityKind',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'topic',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'startsAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endsAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'location',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'capacity',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'organizerName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdByUserIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ActivityStatus',
          columnDefault: '\'active\'',
        ),
        _isp.ColumnDefinition(
          name: 'isDemo',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'campus_activity_status_start_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'startsAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'campus_activity_owner_start_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdByUserIdentifier',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'startsAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iom5v97i.ActivityDetails) {
      return _iom5v97i.ActivityDetails.fromJson(data) as T;
    }
    if (t == _idjzi6az.ActivityErrorCode) {
      return _idjzi6az.ActivityErrorCode.fromJson(data) as T;
    }
    if (t == _ixtu7ny3.ActivityException) {
      return _ixtu7ny3.ActivityException.fromJson(data) as T;
    }
    if (t == _ikhhbudg.ActivityKind) {
      return _ikhhbudg.ActivityKind.fromJson(data) as T;
    }
    if (t == _i78jcvve.ActivityPlan) {
      return _i78jcvve.ActivityPlan.fromJson(data) as T;
    }
    if (t == _ikc54jsx.ActivityRsvp) {
      return _ikc54jsx.ActivityRsvp.fromJson(data) as T;
    }
    if (t == _ievczi9g.ActivityStatus) {
      return _ievczi9g.ActivityStatus.fromJson(data) as T;
    }
    if (t == _iz8d91lk.CampusActivity) {
      return _iz8d91lk.CampusActivity.fromJson(data) as T;
    }
    if (t == _iv4m3ter.CreateActivityRequest) {
      return _iv4m3ter.CreateActivityRequest.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _is.getType<_iom5v97i.ActivityDetails?>()) {
      return (data != null ? _iom5v97i.ActivityDetails.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idjzi6az.ActivityErrorCode?>()) {
      return (data != null ? _idjzi6az.ActivityErrorCode.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixtu7ny3.ActivityException?>()) {
      return (data != null ? _ixtu7ny3.ActivityException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikhhbudg.ActivityKind?>()) {
      return (data != null ? _ikhhbudg.ActivityKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i78jcvve.ActivityPlan?>()) {
      return (data != null ? _i78jcvve.ActivityPlan.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikc54jsx.ActivityRsvp?>()) {
      return (data != null ? _ikc54jsx.ActivityRsvp.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ievczi9g.ActivityStatus?>()) {
      return (data != null ? _ievczi9g.ActivityStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iz8d91lk.CampusActivity?>()) {
      return (data != null ? _iz8d91lk.CampusActivity.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv4m3ter.CreateActivityRequest?>()) {
      return (data != null
              ? _iv4m3ter.CreateActivityRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<_imev5sfu.CampusActivity>) {
      return (data as List)
              .map((e) => deserialize<_imev5sfu.CampusActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i1ksolij.ActivityPlan>) {
      return (data as List)
              .map((e) => deserialize<_i1ksolij.ActivityPlan>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iom5v97i.ActivityDetails => 'ActivityDetails',
      _idjzi6az.ActivityErrorCode => 'ActivityErrorCode',
      _ixtu7ny3.ActivityException => 'ActivityException',
      _ikhhbudg.ActivityKind => 'ActivityKind',
      _i78jcvve.ActivityPlan => 'ActivityPlan',
      _ikc54jsx.ActivityRsvp => 'ActivityRsvp',
      _ievczi9g.ActivityStatus => 'ActivityStatus',
      _iz8d91lk.CampusActivity => 'CampusActivity',
      _iv4m3ter.CreateActivityRequest => 'CreateActivityRequest',
      _izw8z7ou.Greeting => 'Greeting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('campus_loop.', '');
    }

    switch (data) {
      case _iom5v97i.ActivityDetails():
        return 'ActivityDetails';
      case _idjzi6az.ActivityErrorCode():
        return 'ActivityErrorCode';
      case _ixtu7ny3.ActivityException():
        return 'ActivityException';
      case _ikhhbudg.ActivityKind():
        return 'ActivityKind';
      case _i78jcvve.ActivityPlan():
        return 'ActivityPlan';
      case _ikc54jsx.ActivityRsvp():
        return 'ActivityRsvp';
      case _ievczi9g.ActivityStatus():
        return 'ActivityStatus';
      case _iz8d91lk.CampusActivity():
        return 'CampusActivity';
      case _iv4m3ter.CreateActivityRequest():
        return 'CreateActivityRequest';
      case _izw8z7ou.Greeting():
        return 'Greeting';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ActivityDetails') {
      return deserialize<_iom5v97i.ActivityDetails>(data['data']);
    }
    if (dataClassName == 'ActivityErrorCode') {
      return deserialize<_idjzi6az.ActivityErrorCode>(data['data']);
    }
    if (dataClassName == 'ActivityException') {
      return deserialize<_ixtu7ny3.ActivityException>(data['data']);
    }
    if (dataClassName == 'ActivityKind') {
      return deserialize<_ikhhbudg.ActivityKind>(data['data']);
    }
    if (dataClassName == 'ActivityPlan') {
      return deserialize<_i78jcvve.ActivityPlan>(data['data']);
    }
    if (dataClassName == 'ActivityRsvp') {
      return deserialize<_ikc54jsx.ActivityRsvp>(data['data']);
    }
    if (dataClassName == 'ActivityStatus') {
      return deserialize<_ievczi9g.ActivityStatus>(data['data']);
    }
    if (dataClassName == 'CampusActivity') {
      return deserialize<_iz8d91lk.CampusActivity>(data['data']);
    }
    if (dataClassName == 'CreateActivityRequest') {
      return deserialize<_iv4m3ter.CreateActivityRequest>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('campus_loop', this);
    _iacs.Protocol().registerHostProtocol('campus_loop', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ikc54jsx.ActivityRsvp:
        return _ikc54jsx.ActivityRsvp.t;
      case _iz8d91lk.CampusActivity:
        return _iz8d91lk.CampusActivity.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'campus_loop';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
