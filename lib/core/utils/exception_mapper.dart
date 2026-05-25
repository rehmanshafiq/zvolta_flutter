import 'package:zvolta_flutter/core/errors/exceptions.dart';
import 'package:zvolta_flutter/core/errors/failures.dart';

/// Maps data-layer exceptions to domain failures.
class ExceptionMapper {
  const ExceptionMapper();

  Failure map(Object error) {
    if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        statusCode: error.statusCode,
      );
    }

    if (error is NetworkException) {
      return NetworkFailure(message: error.message);
    }

    if (error is CacheException) {
      return CacheFailure(message: error.message);
    }

    if (error is UnknownException) {
      return UnknownFailure(message: error.message);
    }

    return UnknownFailure(message: error.toString());
  }
}
