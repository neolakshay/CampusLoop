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
import 'package:campus_loop_server/src/generated/protocol.dart' as _iu1yuky3;
import 'package:serverpod/serverpod.dart' as _is;
import '../../activities/models/campus_activity.dart' as _i5b8cj66;

abstract class ActivityPlan
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ActivityPlan._({
    required this.activity,
    required this.isOrganizer,
    required this.isAttending,
    this.joinedAt,
  });

  factory ActivityPlan({
    required _i5b8cj66.CampusActivity activity,
    required bool isOrganizer,
    required bool isAttending,
    DateTime? joinedAt,
  }) = _ActivityPlanImpl;

  factory ActivityPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityPlan(
      activity: _iu1yuky3.Protocol().deserialize<_i5b8cj66.CampusActivity>(
        jsonSerialization['activity'],
      ),
      isOrganizer: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isOrganizer'],
      ),
      isAttending: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isAttending'],
      ),
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  _i5b8cj66.CampusActivity activity;

  bool isOrganizer;

  bool isAttending;

  DateTime? joinedAt;

  /// Returns a shallow copy of this [ActivityPlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ActivityPlan copyWith({
    _i5b8cj66.CampusActivity? activity,
    bool? isOrganizer,
    bool? isAttending,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityPlan',
      'activity': activity.toJson(),
      'isOrganizer': isOrganizer,
      'isAttending': isAttending,
      if (joinedAt != null) 'joinedAt': joinedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActivityPlan',
      'activity': activity.toJsonForProtocol(),
      'isOrganizer': isOrganizer,
      'isAttending': isAttending,
      if (joinedAt != null) 'joinedAt': joinedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActivityPlanImpl extends ActivityPlan {
  _ActivityPlanImpl({
    required _i5b8cj66.CampusActivity activity,
    required bool isOrganizer,
    required bool isAttending,
    DateTime? joinedAt,
  }) : super._(
         activity: activity,
         isOrganizer: isOrganizer,
         isAttending: isAttending,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [ActivityPlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ActivityPlan copyWith({
    _i5b8cj66.CampusActivity? activity,
    bool? isOrganizer,
    bool? isAttending,
    Object? joinedAt = _Undefined,
  }) {
    return ActivityPlan(
      activity: activity ?? this.activity.copyWith(),
      isOrganizer: isOrganizer ?? this.isOrganizer,
      isAttending: isAttending ?? this.isAttending,
      joinedAt: joinedAt is DateTime? ? joinedAt : this.joinedAt,
    );
  }
}
