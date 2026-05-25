import 'package:dio/dio.dart';
import 'package:zvolta_flutter/core/errors/exceptions.dart';

/// Parses Dio and other errors into typed [AppException]s.
class ErrorParser {
  const ErrorParser();

  Object parse(Object error) {
    if (error is DioException) {
      return _parseDioError(error);
    }

    if (error is ServerException ||
        error is NetworkException ||
        error is CacheException ||
        error is UnknownException) {
      return error;
    }

    return UnknownException(message: error.toString());
  }

  Object _parseDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _parseBadResponse(error);
      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request was cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownException(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }

  ServerException _parseBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _extractMessage(error.response?.data) ??
        error.message ??
        'Server error occurred';

    return ServerException(message: message, statusCode: statusCode);
  }

  String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return null;
  }
}
