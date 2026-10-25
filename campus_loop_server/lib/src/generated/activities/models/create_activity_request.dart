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

abstract class CreateActivityRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CreateActivityRequest._({
    required this.kind,
    required this.title,
    required this.description,
    this.topic,
    required this.startsAt,
    this.endsAt,
    required this.location,
    this.capacity,
    required this.organizerName,
  });

  factory CreateActivityRequest({
    required _iq08lfi8.ActivityKind kind,
    required String title,
    required String description,
    String? topic,
    required DateTime startsAt,
    DateTime? endsAt,
    required String location,
    int? capacity,
    required String organizerName,
  }) = _CreateActivityRequestImpl;

  factory CreateActivityRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CreateActivityRequest(
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
    );
  }

  _iq08lfi8.ActivityKind kind;

  String title;

  String description;

  String? topic;

  DateTime startsAt;

  DateTime? endsAt;

  String location;

  int? capacity;

  String organizerName;

  /// Returns a shallow copy of this [CreateActivityRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CreateActivityRequest copyWith({
    _iq08lfi8.ActivityKind? kind,
    String? title,
    String? description,
    String? topic,
    DateTime? startsAt,
    DateTime? endsAt,
    String? location,
    int? capacity,
    String? organizerName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreateActivityRequest',
      'kind': kind.toJson(),
      'title': title,
      'description': description,
      if (topic != null) 'topic': topic,
      'startsAt': startsAt.toJson(),
      if (endsAt != null) 'endsAt': endsAt?.toJson(),
      'location': location,
      if (capacity != null) 'capacity': capacity,
      'organizerName': organizerName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CreateActivityRequest',
      'kind': kind.toJson(),
      'title': title,
      'description': description,
      if (topic != null) 'topic': topic,
      'startsAt': startsAt.toJson(),
      if (endsAt != null) 'endsAt': endsAt?.toJson(),
      'location': location,
      if (capacity != null) 'capacity': capacity,
      'organizerName': organizerName,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreateActivityRequestImpl extends CreateActivityRequest {
  _CreateActivityRequestImpl({
    required _iq08lfi8.ActivityKind kind,
    required String title,
    required String description,
    String? topic,
    required DateTime startsAt,
    DateTime? endsAt,
    required String location,
    int? capacity,
    required String organizerName,
  }) : super._(
         kind: kind,
         title: title,
         description: description,
         topic: topic,
         startsAt: startsAt,
         endsAt: endsAt,
         location: location,
         capacity: capacity,
         organizerName: organizerName,
       );

  /// Returns a shallow copy of this [CreateActivityRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CreateActivityRequest copyWith({
    _iq08lfi8.ActivityKind? kind,
    String? title,
    String? description,
    Object? topic = _Undefined,
    DateTime? startsAt,
    Object? endsAt = _Undefined,
    String? location,
    Object? capacity = _Undefined,
    String? organizerName,
  }) {
    return CreateActivityRequest(
      kind: kind ?? this.kind,
      title: title ?? this.title,
      description: description ?? this.description,
      topic: topic is String? ? topic : this.topic,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt is DateTime? ? endsAt : this.endsAt,
      location: location ?? this.location,
      capacity: capacity is int? ? capacity : this.capacity,
      organizerName: organizerName ?? this.organizerName,
    );
  }
}
