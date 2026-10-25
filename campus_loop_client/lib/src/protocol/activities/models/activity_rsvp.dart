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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ActivityRsvp
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ActivityRsvp._({
    this.id,
    required this.activityId,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory ActivityRsvp({
    int? id,
    required int activityId,
    DateTime? joinedAt,
  }) = _ActivityRsvpImpl;

  factory ActivityRsvp.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityRsvp(
      id: jsonSerialization['id'] as int?,
      activityId: jsonSerialization['activityId'] as int,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int activityId;

  DateTime joinedAt;

  /// Returns a shallow copy of this [ActivityRsvp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ActivityRsvp copyWith({
    int? id,
    int? activityId,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityRsvp',
      if (id != null) 'id': id,
      'activityId': activityId,
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActivityRsvpImpl extends ActivityRsvp {
  _ActivityRsvpImpl({
    int? id,
    required int activityId,
    DateTime? joinedAt,
  }) : super._(
         id: id,
         activityId: activityId,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [ActivityRsvp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ActivityRsvp copyWith({
    Object? id = _Undefined,
    int? activityId,
    DateTime? joinedAt,
  }) {
    return ActivityRsvp(
      id: id is int? ? id : this.id,
      activityId: activityId ?? this.activityId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
