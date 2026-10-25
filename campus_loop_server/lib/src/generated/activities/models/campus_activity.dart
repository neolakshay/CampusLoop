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
import 'package:serverpod/serverpod.dart' as _is;
import '../../activities/models/activity_kind.dart' as _iq08lfi8;
import '../../activities/models/activity_status.dart' as _ivwebnta;

abstract class CampusActivity
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CampusActivity._({
    this.id,
    required this.kind,
    required this.title,
    required this.description,
    this.topic,
    required this.startsAt,
    this.endsAt,
    required this.location,
    this.capacity,
    required this.organizerName,
    this.createdByUserIdentifier,
    DateTime? createdAt,
    _ivwebnta.ActivityStatus? status,
    bool? isDemo,
  }) : createdAt = createdAt ?? DateTime.now(),
       status = status ?? _ivwebnta.ActivityStatus.active,
       isDemo = isDemo ?? false;

  factory CampusActivity({
    int? id,
    required _iq08lfi8.ActivityKind kind,
    required String title,
    required String description,
    String? topic,
    required DateTime startsAt,
    DateTime? endsAt,
    required String location,
    int? capacity,
    required String organizerName,
    String? createdByUserIdentifier,
    DateTime? createdAt,
    _ivwebnta.ActivityStatus? status,
    bool? isDemo,
  }) = _CampusActivityImpl;

  factory CampusActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusActivity(
      id: jsonSerialization['id'] as int?,
      kind: _iq08lfi8.ActivityKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      topic: jsonSerialization['topic'] as String?,
      startsAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startsAt'],
      ),
      endsAt: jsonSerialization['endsAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endsAt']),
      location: jsonSerialization['location'] as String,
      capacity: jsonSerialization['capacity'] as int?,
      organizerName: jsonSerialization['organizerName'] as String,
      createdByUserIdentifier:
          jsonSerialization['createdByUserIdentifier'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      status: jsonSerialization['status'] == null
          ? null
          : _ivwebnta.ActivityStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      isDemo: jsonSerialization['isDemo'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
    );
  }

  static final t = CampusActivityTable();

  static const db = CampusActivityRepository._();

  @override
  int? id;

  _iq08lfi8.ActivityKind kind;

  String title;

  String description;

  String? topic;

  DateTime startsAt;

  DateTime? endsAt;

  String location;

  int? capacity;

  String organizerName;

  String? createdByUserIdentifier;

  DateTime createdAt;

  _ivwebnta.ActivityStatus status;

  bool isDemo;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CampusActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CampusActivity copyWith({
    int? id,
    _iq08lfi8.ActivityKind? kind,
    String? title,
    String? description,
    String? topic,
    DateTime? startsAt,
    DateTime? endsAt,
    String? location,
    int? capacity,
    String? organizerName,
    String? createdByUserIdentifier,
    DateTime? createdAt,
    _ivwebnta.ActivityStatus? status,
    bool? isDemo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampusActivity',
      if (id != null) 'id': id,
      'kind': kind.toJson(),
      'title': title,
      'description': description,
      if (topic != null) 'topic': topic,
      'startsAt': startsAt.toJson(),
      if (endsAt != null) 'endsAt': endsAt?.toJson(),
      'location': location,
      if (capacity != null) 'capacity': capacity,
      'organizerName': organizerName,
      if (createdByUserIdentifier != null)
        'createdByUserIdentifier': createdByUserIdentifier,
      'createdAt': createdAt.toJson(),
      'status': status.toJson(),
      'isDemo': isDemo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampusActivity',
      if (id != null) 'id': id,
      'kind': kind.toJson(),
      'title': title,
      'description': description,
      if (topic != null) 'topic': topic,
      'startsAt': startsAt.toJson(),
      if (endsAt != null) 'endsAt': endsAt?.toJson(),
      'location': location,
      if (capacity != null) 'capacity': capacity,
      'organizerName': organizerName,
      'createdAt': createdAt.toJson(),
      'status': status.toJson(),
      'isDemo': isDemo,
    };
  }

  static CampusActivityInclude include() {
    return CampusActivityInclude._();
  }

  static CampusActivityIncludeList includeList({
    _is.WhereExpressionBuilder<CampusActivityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusActivityTable>? orderBy,
    _is.OrderByListBuilder<CampusActivityTable>? orderByList,
    CampusActivityInclude? include,
  }) {
    return CampusActivityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampusActivity.t),
      orderByList: orderByList?.call(CampusActivity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampusActivityImpl extends CampusActivity {
  _CampusActivityImpl({
    int? id,
    required _iq08lfi8.ActivityKind kind,
    required String title,
    required String description,
    String? topic,
    required DateTime startsAt,
    DateTime? endsAt,
    required String location,
    int? capacity,
    required String organizerName,
    String? createdByUserIdentifier,
    DateTime? createdAt,
    _ivwebnta.ActivityStatus? status,
    bool? isDemo,
  }) : super._(
         id: id,
         kind: kind,
         title: title,
         description: description,
         topic: topic,
         startsAt: startsAt,
         endsAt: endsAt,
         location: location,
         capacity: capacity,
         organizerName: organizerName,
         createdByUserIdentifier: createdByUserIdentifier,
         createdAt: createdAt,
         status: status,
         isDemo: isDemo,
       );

  /// Returns a shallow copy of this [CampusActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CampusActivity copyWith({
    Object? id = _Undefined,
    _iq08lfi8.ActivityKind? kind,
    String? title,
    String? description,
    Object? topic = _Undefined,
    DateTime? startsAt,
    Object? endsAt = _Undefined,
    String? location,
    Object? capacity = _Undefined,
    String? organizerName,
    Object? createdByUserIdentifier = _Undefined,
    DateTime? createdAt,
    _ivwebnta.ActivityStatus? status,
    bool? isDemo,
  }) {
    return CampusActivity(
      id: id is int? ? id : this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      description: description ?? this.description,
      topic: topic is String? ? topic : this.topic,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt is DateTime? ? endsAt : this.endsAt,
      location: location ?? this.location,
      capacity: capacity is int? ? capacity : this.capacity,
      organizerName: organizerName ?? this.organizerName,
      createdByUserIdentifier: createdByUserIdentifier is String?
          ? createdByUserIdentifier
          : this.createdByUserIdentifier,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}

class CampusActivityUpdateTable extends _is.UpdateTable<CampusActivityTable> {
  CampusActivityUpdateTable(super.table);

  _is.ColumnValue<_iq08lfi8.ActivityKind, _iq08lfi8.ActivityKind> kind(
    _iq08lfi8.ActivityKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> topic(String? value) => _is.ColumnValue(
    table.topic,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startsAt(DateTime value) =>
      _is.ColumnValue(
        table.startsAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endsAt(DateTime? value) =>
      _is.ColumnValue(
        table.endsAt,
        value,
      );

  _is.ColumnValue<String, String> location(String value) => _is.ColumnValue(
    table.location,
    value,
  );

  _is.ColumnValue<int, int> capacity(int? value) => _is.ColumnValue(
    table.capacity,
    value,
  );

  _is.ColumnValue<String, String> organizerName(String value) =>
      _is.ColumnValue(
        table.organizerName,
        value,
      );

  _is.ColumnValue<String, String> createdByUserIdentifier(String? value) =>
      _is.ColumnValue(
        table.createdByUserIdentifier,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<_ivwebnta.ActivityStatus, _ivwebnta.ActivityStatus> status(
    _ivwebnta.ActivityStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<bool, bool> isDemo(bool value) => _is.ColumnValue(
    table.isDemo,
    value,
  );
}

class CampusActivityTable extends _is.Table<int?> {
  CampusActivityTable({super.tableRelation})
    : super(tableName: 'campus_activity') {
    updateTable = CampusActivityUpdateTable(this);
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    topic = _is.ColumnString(
      'topic',
      this,
    );
    startsAt = _is.ColumnDateTime(
      'startsAt',
      this,
    );
    endsAt = _is.ColumnDateTime(
      'endsAt',
      this,
    );
    location = _is.ColumnString(
      'location',
      this,
    );
    capacity = _is.ColumnInt(
      'capacity',
      this,
    );
    organizerName = _is.ColumnString(
      'organizerName',
      this,
    );
    createdByUserIdentifier = _is.ColumnString(
      'createdByUserIdentifier',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    isDemo = _is.ColumnBool(
      'isDemo',
      this,
      hasDefault: true,
    );
  }

  late final CampusActivityUpdateTable updateTable;

  late final _is.ColumnEnum<_iq08lfi8.ActivityKind> kind;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnString topic;

  late final _is.ColumnDateTime startsAt;

  late final _is.ColumnDateTime endsAt;

  late final _is.ColumnString location;

  late final _is.ColumnInt capacity;

  late final _is.ColumnString organizerName;

  late final _is.ColumnString createdByUserIdentifier;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnEnum<_ivwebnta.ActivityStatus> status;

  late final _is.ColumnBool isDemo;

  @override
  List<_is.Column> get columns => [
    id,
    kind,
    title,
    description,
    topic,
    startsAt,
    endsAt,
    location,
    capacity,
    organizerName,
    createdByUserIdentifier,
    createdAt,
    status,
    isDemo,
  ];
}

class CampusActivityInclude extends _is.IncludeObject {
  CampusActivityInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CampusActivity.t;
}

class CampusActivityIncludeList extends _is.IncludeList {
  CampusActivityIncludeList._({
    _is.WhereExpressionBuilder<CampusActivityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CampusActivity.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CampusActivity.t;
}

class CampusActivityRepository {
  const CampusActivityRepository._();

  /// Returns a list of [CampusActivity]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<CampusActivity>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusActivityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusActivityTable>? orderBy,
    _is.OrderByListBuilder<CampusActivityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CampusActivity>(
      where: where?.call(CampusActivity.t),
      orderBy: orderBy?.call(CampusActivity.t),
      orderByList: orderByList?.call(CampusActivity.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CampusActivity] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<CampusActivity?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusActivityTable>? where,
    int? offset,
    _is.OrderByBuilder<CampusActivityTable>? orderBy,
    _is.OrderByListBuilder<CampusActivityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CampusActivity>(
      where: where?.call(CampusActivity.t),
      orderBy: orderBy?.call(CampusActivity.t),
      orderByList: orderByList?.call(CampusActivity.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CampusActivity] by its [id] or null if no such row exists.
  Future<CampusActivity?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CampusActivity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CampusActivity]s in the list and returns the inserted rows.
  ///
  /// The returned [CampusActivity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusActivity>> insert(
    _is.DatabaseSession session,
    List<CampusActivity> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CampusActivity>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CampusActivity] and returns the inserted row.
  ///
  /// The returned [CampusActivity] will have its `id` field set.
  Future<CampusActivity> insertRow(
    _is.DatabaseSession session,
    CampusActivity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CampusActivity>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CampusActivity]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [CampusActivity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusActivity>> upsert(
    _is.DatabaseSession session,
    List<CampusActivity> rows, {
    required _is.ColumnSelections<CampusActivityTable> conflictColumns,
    _is.ColumnSelections<CampusActivityTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusActivityTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CampusActivity>(
      rows,
      conflictColumns: conflictColumns(CampusActivity.t),
      updateColumns: updateColumns?.call(CampusActivity.t),
      updateWhere: updateWhere?.call(CampusActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CampusActivity] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [CampusActivity] will have its `id` field set.
  Future<CampusActivity?> upsertRow(
    _is.DatabaseSession session,
    CampusActivity row, {
    required _is.ColumnSelections<CampusActivityTable> conflictColumns,
    _is.ColumnSelections<CampusActivityTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusActivityTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CampusActivity>(
      row,
      conflictColumns: conflictColumns(CampusActivity.t),
      updateColumns: updateColumns?.call(CampusActivity.t),
      updateWhere: updateWhere?.call(CampusActivity.t),
      transaction: transaction,
    );
  }

  /// Updates all [CampusActivity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusActivity>> update(
    _is.DatabaseSession session,
    List<CampusActivity> rows, {
    _is.ColumnSelections<CampusActivityTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CampusActivity>(
      rows,
      columns: columns?.call(CampusActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CampusActivity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CampusActivity> updateRow(
    _is.DatabaseSession session,
    CampusActivity row, {
    _is.ColumnSelections<CampusActivityTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CampusActivity>(
      row,
      columns: columns?.call(CampusActivity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CampusActivity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CampusActivity?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CampusActivityUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CampusActivity>(
      id,
      columnValues: columnValues(CampusActivity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CampusActivity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusActivity>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CampusActivityUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CampusActivityTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusActivityTable>? orderBy,
    _is.OrderByListBuilder<CampusActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CampusActivity>(
      columnValues: columnValues(CampusActivity.t.updateTable),
      where: where(CampusActivity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampusActivity.t),
      orderByList: orderByList?.call(CampusActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CampusActivity]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusActivity>> delete(
    _is.DatabaseSession session,
    List<CampusActivity> rows, {
    _is.OrderByBuilder<CampusActivityTable>? orderBy,
    _is.OrderByListBuilder<CampusActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CampusActivity>(
      rows,
      orderBy: orderBy?.call(CampusActivity.t),
      orderByList: orderByList?.call(CampusActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CampusActivity].
  Future<CampusActivity> deleteRow(
    _is.DatabaseSession session,
    CampusActivity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CampusActivity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CampusActivity>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusActivityTable> where,
    _is.OrderByBuilder<CampusActivityTable>? orderBy,
    _is.OrderByListBuilder<CampusActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CampusActivity>(
      where: where(CampusActivity.t),
      orderBy: orderBy?.call(CampusActivity.t),
      orderByList: orderByList?.call(CampusActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusActivityTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CampusActivity>(
      where: where?.call(CampusActivity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CampusActivity] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusActivityTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CampusActivity>(
      where: where(CampusActivity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
