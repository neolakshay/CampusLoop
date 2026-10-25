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
import 'package:campus_loop_client/src/protocol/protocol.dart' as _i5x4ep33;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../activities/models/campus_activity.dart' as _i5b8cj66;

abstract class ActivityDetails
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ActivityDetails._({
    required this.activity,
    required this.attendeeCount,
    required this.isAttending,
    required this.isOrganizer,
  });

  factory ActivityDetails({
    required _i5b8cj66.CampusActivity activity,
    required int attendeeCount,
    required bool isAttending,
    required bool isOrganizer,
  }) = _ActivityDetailsImpl;

  factory ActivityDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityDetails(
      activity: _i5x4ep33.Protocol().deserialize<_i5b8cj66.CampusActivity>(
        jsonSerialization['activity'],
      ),
      attendeeCount: jsonSerialization['attendeeCount'] as int,
      isAttending: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isAttending'],
      ),
      isOrganizer: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isOrganizer'],
      ),
    );
  }

  _i5b8cj66.CampusActivity activity;

  int attendeeCount;

  bool isAttending;

  bool isOrganizer;

  /// Returns a shallow copy of this [ActivityDetails]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ActivityDetails copyWith({
    _i5b8cj66.CampusActivity? activity,
    int? attendeeCount,
    bool? isAttending,
    bool? isOrganizer,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityDetails',
      'activity': activity.toJson(),
      'attendeeCount': attendeeCount,
      'isAttending': isAttending,
      'isOrganizer': isOrganizer,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActivityDetails',
      'activity': activity.toJsonForProtocol(),
      'attendeeCount': attendeeCount,
      'isAttending': isAttending,
      'isOrganizer': isOrganizer,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ActivityDetailsImpl extends ActivityDetails {
  _ActivityDetailsImpl({
    required _i5b8cj66.CampusActivity activity,
    required int attendeeCount,
    required bool isAttending,
    required bool isOrganizer,
  }) : super._(
         activity: activity,
         attendeeCount: attendeeCount,
         isAttending: isAttending,
         isOrganizer: isOrganizer,
       );

  /// Returns a shallow copy of this [ActivityDetails]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ActivityDetails copyWith({
    _i5b8cj66.CampusActivity? activity,
    int? attendeeCount,
    bool? isAttending,
    bool? isOrganizer,
  }) {
    return ActivityDetails(
      activity: activity ?? this.activity.copyWith(),
      attendeeCount: attendeeCount ?? this.attendeeCount,
      isAttending: isAttending ?? this.isAttending,
      isOrganizer: isOrganizer ?? this.isOrganizer,
    );
  }
}
