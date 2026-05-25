/// Thrown when the remote server returns an error response.
class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown when cached or local data cannot be read or written.
class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when the device has no network connectivity.
class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection'});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when an unexpected error occurs.
class UnknownException implements Exception {
  const UnknownException({required this.message});

  final String message;

  @override
  String toString() => 'UnknownException: $message';
}
