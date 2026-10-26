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
import '../../auth/models/username_password_auth_error_code.dart' as _ix0w7xlj;

abstract class UsernamePasswordAuthException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  UsernamePasswordAuthException._({
    required this.code,
    required this.message,
    this.field,
  });

  factory UsernamePasswordAuthException({
    required _ix0w7xlj.UsernamePasswordAuthErrorCode code,
    required String message,
    String? field,
  }) = _UsernamePasswordAuthExceptionImpl;

  factory UsernamePasswordAuthException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UsernamePasswordAuthException(
      code: _ix0w7xlj.UsernamePasswordAuthErrorCode.fromJson(
        (jsonSerialization['code'] as String),
      ),
      message: jsonSerialization['message'] as String,
      field: jsonSerialization['field'] as String?,
    );
  }

  _ix0w7xlj.UsernamePasswordAuthErrorCode code;

  String message;

  String? field;

  /// Returns a shallow copy of this [UsernamePasswordAuthException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UsernamePasswordAuthException copyWith({
    _ix0w7xlj.UsernamePasswordAuthErrorCode? code,
    String? message,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UsernamePasswordAuthException',
      'code': code.toJson(),
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UsernamePasswordAuthException',
      'code': code.toJson(),
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  String toString() {
    return 'UsernamePasswordAuthException(code: $code, message: $message, field: $field)';
  }
}

class _Undefined {}

class _UsernamePasswordAuthExceptionImpl extends UsernamePasswordAuthException {
  _UsernamePasswordAuthExceptionImpl({
    required _ix0w7xlj.UsernamePasswordAuthErrorCode code,
    required String message,
    String? field,
  }) : super._(
         code: code,
         message: message,
         field: field,
       );

  /// Returns a shallow copy of this [UsernamePasswordAuthException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UsernamePasswordAuthException copyWith({
    _ix0w7xlj.UsernamePasswordAuthErrorCode? code,
    String? message,
    Object? field = _Undefined,
  }) {
    return UsernamePasswordAuthException(
      code: code ?? this.code,
      message: message ?? this.message,
      field: field is String? ? field : this.field,
    );
  }
}
