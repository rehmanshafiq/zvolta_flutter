import 'package:equatable/equatable.dart';

/// Generic wrapper for standardized API responses.
class ApiResponse<T> extends Equatable {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] as bool? ?? true,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
      statusCode: json['status_code'] as int?,
    );
  }

  @override
  List<Object?> get props => [success, data, message, statusCode];
}
