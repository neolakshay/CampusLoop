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

abstract class UsernamePasswordAccount
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UsernamePasswordAccount._({
    this.id,
    required this.authUserId,
    required this.username,
    required this.usernameKey,
    required this.passwordHash,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UsernamePasswordAccount({
    int? id,
    required _is.UuidValue authUserId,
    required String username,
    required String usernameKey,
    required String passwordHash,
    DateTime? createdAt,
  }) = _UsernamePasswordAccountImpl;

  factory UsernamePasswordAccount.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UsernamePasswordAccount(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      username: jsonSerialization['username'] as String,
      usernameKey: jsonSerialization['usernameKey'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = UsernamePasswordAccountTable();

  static const db = UsernamePasswordAccountRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String username;

  String usernameKey;

  String passwordHash;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UsernamePasswordAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UsernamePasswordAccount copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? username,
    String? usernameKey,
    String? passwordHash,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UsernamePasswordAccount',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'username': username,
      'usernameKey': usernameKey,
      'passwordHash': passwordHash,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static UsernamePasswordAccountInclude include() {
    return UsernamePasswordAccountInclude._();
  }

  static UsernamePasswordAccountIncludeList includeList({
    _is.WhereExpressionBuilder<UsernamePasswordAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UsernamePasswordAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernamePasswordAccountTable>? orderByList,
    UsernamePasswordAccountInclude? include,
  }) {
    return UsernamePasswordAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UsernamePasswordAccount.t),
      orderByList: orderByList?.call(UsernamePasswordAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UsernamePasswordAccountImpl extends UsernamePasswordAccount {
  _UsernamePasswordAccountImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String username,
    required String usernameKey,
    required String passwordHash,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         username: username,
         usernameKey: usernameKey,
         passwordHash: passwordHash,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UsernamePasswordAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UsernamePasswordAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? username,
    String? usernameKey,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return UsernamePasswordAccount(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      username: username ?? this.username,
      usernameKey: usernameKey ?? this.usernameKey,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UsernamePasswordAccountUpdateTable
    extends _is.UpdateTable<UsernamePasswordAccountTable> {
  UsernamePasswordAccountUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> username(String value) => _is.ColumnValue(
    table.username,
    value,
  );

  _is.ColumnValue<String, String> usernameKey(String value) => _is.ColumnValue(
    table.usernameKey,
    value,
  );

  _is.ColumnValue<String, String> passwordHash(String value) => _is.ColumnValue(
    table.passwordHash,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class UsernamePasswordAccountTable extends _is.Table<int?> {
  UsernamePasswordAccountTable({super.tableRelation})
    : super(tableName: 'username_password_account') {
    updateTable = UsernamePasswordAccountUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    username = _is.ColumnString(
      'username',
      this,
    );
    usernameKey = _is.ColumnString(
      'usernameKey',
      this,
    );
    passwordHash = _is.ColumnString(
      'passwordHash',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final UsernamePasswordAccountUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString username;

  late final _is.ColumnString usernameKey;

  late final _is.ColumnString passwordHash;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    username,
    usernameKey,
    passwordHash,
    createdAt,
  ];
}

class UsernamePasswordAccountInclude extends _is.IncludeObject {
  UsernamePasswordAccountInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UsernamePasswordAccount.t;
}

class UsernamePasswordAccountIncludeList extends _is.IncludeList {
  UsernamePasswordAccountIncludeList._({
    _is.WhereExpressionBuilder<UsernamePasswordAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UsernamePasswordAccount.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UsernamePasswordAccount.t;
}

class UsernamePasswordAccountRepository {
  const UsernamePasswordAccountRepository._();

  /// Returns a list of [UsernamePasswordAccount]s matching the given query parameters.
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
  Future<List<UsernamePasswordAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UsernamePasswordAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UsernamePasswordAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernamePasswordAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UsernamePasswordAccount>(
      where: where?.call(UsernamePasswordAccount.t),
      orderBy: orderBy?.call(UsernamePasswordAccount.t),
      orderByList: orderByList?.call(UsernamePasswordAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UsernamePasswordAccount] matching the given query parameters.
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
  Future<UsernamePasswordAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UsernamePasswordAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<UsernamePasswordAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernamePasswordAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UsernamePasswordAccount>(
      where: where?.call(UsernamePasswordAccount.t),
      orderBy: orderBy?.call(UsernamePasswordAccount.t),
      orderByList: orderByList?.call(UsernamePasswordAccount.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UsernamePasswordAccount] by its [id] or null if no such row exists.
  Future<UsernamePasswordAccount?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UsernamePasswordAccount>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UsernamePasswordAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [UsernamePasswordAccount]s will have their `id` fields set.
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
  Future<List<UsernamePasswordAccount>> insert(
    _is.DatabaseSession session,
    List<UsernamePasswordAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UsernamePasswordAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UsernamePasswordAccount] and returns the inserted row.
  ///
  /// The returned [UsernamePasswordAccount] will have its `id` field set.
  Future<UsernamePasswordAccount> insertRow(
    _is.DatabaseSession session,
    UsernamePasswordAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UsernamePasswordAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UsernamePasswordAccount]s in the list and returns the resulting rows.
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
  /// The returned [UsernamePasswordAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernamePasswordAccount>> upsert(
    _is.DatabaseSession session,
    List<UsernamePasswordAccount> rows, {
    required _is.ColumnSelections<UsernamePasswordAccountTable> conflictColumns,
    _is.ColumnSelections<UsernamePasswordAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<UsernamePasswordAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UsernamePasswordAccount>(
      rows,
      conflictColumns: conflictColumns(UsernamePasswordAccount.t),
      updateColumns: updateColumns?.call(UsernamePasswordAccount.t),
      updateWhere: updateWhere?.call(UsernamePasswordAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UsernamePasswordAccount] and returns the resulting row.
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
  /// The returned [UsernamePasswordAccount] will have its `id` field set.
  Future<UsernamePasswordAccount?> upsertRow(
    _is.DatabaseSession session,
    UsernamePasswordAccount row, {
    required _is.ColumnSelections<UsernamePasswordAccountTable> conflictColumns,
    _is.ColumnSelections<UsernamePasswordAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<UsernamePasswordAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UsernamePasswordAccount>(
      row,
      conflictColumns: conflictColumns(UsernamePasswordAccount.t),
      updateColumns: updateColumns?.call(UsernamePasswordAccount.t),
      updateWhere: updateWhere?.call(UsernamePasswordAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [UsernamePasswordAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernamePasswordAccount>> update(
    _is.DatabaseSession session,
    List<UsernamePasswordAccount> rows, {
    _is.ColumnSelections<UsernamePasswordAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UsernamePasswordAccount>(
      rows,
      columns: columns?.call(UsernamePasswordAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UsernamePasswordAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UsernamePasswordAccount> updateRow(
    _is.DatabaseSession session,
    UsernamePasswordAccount row, {
    _is.ColumnSelections<UsernamePasswordAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UsernamePasswordAccount>(
      row,
      columns: columns?.call(UsernamePasswordAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UsernamePasswordAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UsernamePasswordAccount?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UsernamePasswordAccountUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UsernamePasswordAccount>(
      id,
      columnValues: columnValues(UsernamePasswordAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UsernamePasswordAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernamePasswordAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UsernamePasswordAccountUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UsernamePasswordAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UsernamePasswordAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernamePasswordAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UsernamePasswordAccount>(
      columnValues: columnValues(UsernamePasswordAccount.t.updateTable),
      where: where(UsernamePasswordAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UsernamePasswordAccount.t),
      orderByList: orderByList?.call(UsernamePasswordAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UsernamePasswordAccount]s in the list and returns the deleted rows.
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
  Future<List<UsernamePasswordAccount>> delete(
    _is.DatabaseSession session,
    List<UsernamePasswordAccount> rows, {
    _is.OrderByBuilder<UsernamePasswordAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernamePasswordAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UsernamePasswordAccount>(
      rows,
      orderBy: orderBy?.call(UsernamePasswordAccount.t),
      orderByList: orderByList?.call(UsernamePasswordAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UsernamePasswordAccount].
  Future<UsernamePasswordAccount> deleteRow(
    _is.DatabaseSession session,
    UsernamePasswordAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UsernamePasswordAccount>(
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
  Future<List<UsernamePasswordAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UsernamePasswordAccountTable> where,
    _is.OrderByBuilder<UsernamePasswordAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernamePasswordAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UsernamePasswordAccount>(
      where: where(UsernamePasswordAccount.t),
      orderBy: orderBy?.call(UsernamePasswordAccount.t),
      orderByList: orderByList?.call(UsernamePasswordAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UsernamePasswordAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UsernamePasswordAccount>(
      where: where?.call(UsernamePasswordAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UsernamePasswordAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UsernamePasswordAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UsernamePasswordAccount>(
      where: where(UsernamePasswordAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
