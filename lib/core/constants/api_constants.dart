/// API-related constants.
class ApiConstants {
  ApiConstants._();

  /// Replace with your backend URL or load from .env in production.
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String users = '/users';
}
