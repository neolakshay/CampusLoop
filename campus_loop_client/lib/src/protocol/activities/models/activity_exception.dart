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
import '../../activities/models/activity_error_code.dart' as _i1y3l0bg;

abstract class ActivityException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  ActivityException._({
    required this.code,
    required this.message,
    this.field,
  });

  factory ActivityException({
    required _i1y3l0bg.ActivityErrorCode code,
    required String message,
    String? field,
  }) = _ActivityExceptionImpl;

  factory ActivityException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityException(
      code: _i1y3l0bg.ActivityErrorCode.fromJson(
        (jsonSerialization['code'] as String),
      ),
      message: jsonSerialization['message'] as String,
      field: jsonSerialization['field'] as String?,
    );
  }

  _i1y3l0bg.ActivityErrorCode code;

  String message;

  String? field;

  /// Returns a shallow copy of this [ActivityException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ActivityException copyWith({
    _i1y3l0bg.ActivityErrorCode? code,
    String? message,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityException',
      'code': code.toJson(),
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActivityException',
      'code': code.toJson(),
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  String toString() {
    return 'ActivityException(code: $code, message: $message, field: $field)';
  }
}

class _Undefined {}

class _ActivityExceptionImpl extends ActivityException {
  _ActivityExceptionImpl({
    required _i1y3l0bg.ActivityErrorCode code,
    required String message,
    String? field,
  }) : super._(
         code: code,
         message: message,
         field: field,
       );

  /// Returns a shallow copy of this [ActivityException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ActivityException copyWith({
    _i1y3l0bg.ActivityErrorCode? code,
    String? message,
    Object? field = _Undefined,
  }) {
    return ActivityException(
      code: code ?? this.code,
      message: message ?? this.message,
      field: field is String? ? field : this.field,
    );
  }
}
