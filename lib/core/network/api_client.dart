import 'package:dio/dio.dart';
import 'package:zvolta_flutter/core/constants/api_constants.dart';
import 'package:zvolta_flutter/core/network/error_parser.dart';
import 'package:zvolta_flutter/core/network/interceptors.dart';

/// Centralized Dio client used by all API services.
class ApiClient {
  ApiClient({
    required ErrorParser errorParser,
    String? Function()? getToken,
    Dio? dio,
  })  : _errorParser = errorParser,
        _dio = dio ?? Dio() {
    _dio
      ..options = BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        responseType: ResponseType.json,
      )
      ..interceptors.addAll([
        AuthInterceptor(getToken: getToken),
        LoggingInterceptor(),
      ]);
  }

  final Dio _dio;
  final ErrorParser _errorParser;

  Dio get dio => _dio;

  /// GET request with automatic error parsing.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _errorParser.parse(error);
    }
  }

  /// POST request with automatic error parsing.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _errorParser.parse(error);
    }
  }

  /// PUT request with automatic error parsing.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _errorParser.parse(error);
    }
  }

  /// DELETE request with automatic error parsing.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw _errorParser.parse(error);
    }
  }
}
