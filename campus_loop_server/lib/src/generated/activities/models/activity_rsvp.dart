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

abstract class ActivityRsvp
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ActivityRsvp._({
    this.id,
    required this.activityId,
    this.userIdentifier,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory ActivityRsvp({
    int? id,
    required int activityId,
    String? userIdentifier,
    DateTime? joinedAt,
  }) = _ActivityRsvpImpl;

  factory ActivityRsvp.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityRsvp(
      id: jsonSerialization['id'] as int?,
      activityId: jsonSerialization['activityId'] as int,
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = ActivityRsvpTable();

  static const db = ActivityRsvpRepository._();

  @override
  int? id;

  int activityId;

  String? userIdentifier;

  DateTime joinedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ActivityRsvp]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ActivityRsvp copyWith({
    int? id,
    int? activityId,
    String? userIdentifier,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityRsvp',
      if (id != null) 'id': id,
      'activityId': activityId,
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActivityRsvp',
      if (id != null) 'id': id,
      'activityId': activityId,
      'joinedAt': joinedAt.toJson(),
    };
  }

  static ActivityRsvpInclude include() {
    return ActivityRsvpInclude._();
  }

  static ActivityRsvpIncludeList includeList({
    _is.WhereExpressionBuilder<ActivityRsvpTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActivityRsvpTable>? orderBy,
    _is.OrderByListBuilder<ActivityRsvpTable>? orderByList,
    ActivityRsvpInclude? include,
  }) {
    return ActivityRsvpIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActivityRsvp.t),
      orderByList: orderByList?.call(ActivityRsvp.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActivityRsvpImpl extends ActivityRsvp {
  _ActivityRsvpImpl({
    int? id,
    required int activityId,
    String? userIdentifier,
    DateTime? joinedAt,
  }) : super._(
         id: id,
         activityId: activityId,
         userIdentifier: userIdentifier,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [ActivityRsvp]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ActivityRsvp copyWith({
    Object? id = _Undefined,
    int? activityId,
    Object? userIdentifier = _Undefined,
    DateTime? joinedAt,
  }) {
    return ActivityRsvp(
      id: id is int? ? id : this.id,
      activityId: activityId ?? this.activityId,
      userIdentifier: userIdentifier is String?
          ? userIdentifier
          : this.userIdentifier,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class ActivityRsvpUpdateTable extends _is.UpdateTable<ActivityRsvpTable> {
  ActivityRsvpUpdateTable(super.table);

  _is.ColumnValue<int, int> activityId(int value) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String? value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _is.ColumnValue(
        table.joinedAt,
        value,
      );
}

class ActivityRsvpTable extends _is.Table<int?> {
  ActivityRsvpTable({super.tableRelation}) : super(tableName: 'activity_rsvp') {
    updateTable = ActivityRsvpUpdateTable(this);
    activityId = _is.ColumnInt(
      'activityId',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    joinedAt = _is.ColumnDateTime(
      'joinedAt',
      this,
      hasDefault: true,
    );
  }

  late final ActivityRsvpUpdateTable updateTable;

  late final _is.ColumnInt activityId;

  late final _is.ColumnString userIdentifier;

  late final _is.ColumnDateTime joinedAt;

  @override
  List<_is.Column> get columns => [
    id,
    activityId,
    userIdentifier,
    joinedAt,
  ];
}

class ActivityRsvpInclude extends _is.IncludeObject {
  ActivityRsvpInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ActivityRsvp.t;
}

class ActivityRsvpIncludeList extends _is.IncludeList {
  ActivityRsvpIncludeList._({
    _is.WhereExpressionBuilder<ActivityRsvpTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActivityRsvp.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ActivityRsvp.t;
}

class ActivityRsvpRepository {
  const ActivityRsvpRepository._();

  /// Returns a list of [ActivityRsvp]s matching the given query parameters.
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
  Future<List<ActivityRsvp>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActivityRsvpTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActivityRsvpTable>? orderBy,
    _is.OrderByListBuilder<ActivityRsvpTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ActivityRsvp>(
      where: where?.call(ActivityRsvp.t),
      orderBy: orderBy?.call(ActivityRsvp.t),
      orderByList: orderByList?.call(ActivityRsvp.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ActivityRsvp] matching the given query parameters.
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
  Future<ActivityRsvp?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActivityRsvpTable>? where,
    int? offset,
    _is.OrderByBuilder<ActivityRsvpTable>? orderBy,
    _is.OrderByListBuilder<ActivityRsvpTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ActivityRsvp>(
      where: where?.call(ActivityRsvp.t),
      orderBy: orderBy?.call(ActivityRsvp.t),
      orderByList: orderByList?.call(ActivityRsvp.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ActivityRsvp] by its [id] or null if no such row exists.
  Future<ActivityRsvp?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ActivityRsvp>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ActivityRsvp]s in the list and returns the inserted rows.
  ///
  /// The returned [ActivityRsvp]s will have their `id` fields set.
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
  Future<List<ActivityRsvp>> insert(
    _is.DatabaseSession session,
    List<ActivityRsvp> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ActivityRsvp>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ActivityRsvp] and returns the inserted row.
  ///
  /// The returned [ActivityRsvp] will have its `id` field set.
  Future<ActivityRsvp> insertRow(
    _is.DatabaseSession session,
    ActivityRsvp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActivityRsvp>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ActivityRsvp]s in the list and returns the resulting rows.
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
  /// The returned [ActivityRsvp]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivityRsvp>> upsert(
    _is.DatabaseSession session,
    List<ActivityRsvp> rows, {
    required _is.ColumnSelections<ActivityRsvpTable> conflictColumns,
    _is.ColumnSelections<ActivityRsvpTable>? updateColumns,
    _is.WhereExpressionBuilder<ActivityRsvpTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ActivityRsvp>(
      rows,
      conflictColumns: conflictColumns(ActivityRsvp.t),
      updateColumns: updateColumns?.call(ActivityRsvp.t),
      updateWhere: updateWhere?.call(ActivityRsvp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ActivityRsvp] and returns the resulting row.
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
  /// The returned [ActivityRsvp] will have its `id` field set.
  Future<ActivityRsvp?> upsertRow(
    _is.DatabaseSession session,
    ActivityRsvp row, {
    required _is.ColumnSelections<ActivityRsvpTable> conflictColumns,
    _is.ColumnSelections<ActivityRsvpTable>? updateColumns,
    _is.WhereExpressionBuilder<ActivityRsvpTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ActivityRsvp>(
      row,
      conflictColumns: conflictColumns(ActivityRsvp.t),
      updateColumns: updateColumns?.call(ActivityRsvp.t),
      updateWhere: updateWhere?.call(ActivityRsvp.t),
      transaction: transaction,
    );
  }

  /// Updates all [ActivityRsvp]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivityRsvp>> update(
    _is.DatabaseSession session,
    List<ActivityRsvp> rows, {
    _is.ColumnSelections<ActivityRsvpTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ActivityRsvp>(
      rows,
      columns: columns?.call(ActivityRsvp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ActivityRsvp]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActivityRsvp> updateRow(
    _is.DatabaseSession session,
    ActivityRsvp row, {
    _is.ColumnSelections<ActivityRsvpTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActivityRsvp>(
      row,
      columns: columns?.call(ActivityRsvp.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActivityRsvp] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ActivityRsvp?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ActivityRsvpUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ActivityRsvp>(
      id,
      columnValues: columnValues(ActivityRsvp.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ActivityRsvp]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivityRsvp>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ActivityRsvpUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ActivityRsvpTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActivityRsvpTable>? orderBy,
    _is.OrderByListBuilder<ActivityRsvpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ActivityRsvp>(
      columnValues: columnValues(ActivityRsvp.t.updateTable),
      where: where(ActivityRsvp.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActivityRsvp.t),
      orderByList: orderByList?.call(ActivityRsvp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ActivityRsvp]s in the list and returns the deleted rows.
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
  Future<List<ActivityRsvp>> delete(
    _is.DatabaseSession session,
    List<ActivityRsvp> rows, {
    _is.OrderByBuilder<ActivityRsvpTable>? orderBy,
    _is.OrderByListBuilder<ActivityRsvpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ActivityRsvp>(
      rows,
      orderBy: orderBy?.call(ActivityRsvp.t),
      orderByList: orderByList?.call(ActivityRsvp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ActivityRsvp].
  Future<ActivityRsvp> deleteRow(
    _is.DatabaseSession session,
    ActivityRsvp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActivityRsvp>(
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
  Future<List<ActivityRsvp>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ActivityRsvpTable> where,
    _is.OrderByBuilder<ActivityRsvpTable>? orderBy,
    _is.OrderByListBuilder<ActivityRsvpTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ActivityRsvp>(
      where: where(ActivityRsvp.t),
      orderBy: orderBy?.call(ActivityRsvp.t),
      orderByList: orderByList?.call(ActivityRsvp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActivityRsvpTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ActivityRsvp>(
      where: where?.call(ActivityRsvp.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ActivityRsvp] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ActivityRsvpTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ActivityRsvp>(
      where: where(ActivityRsvp.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
