import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
/// Failures are returned to the presentation layer instead of raw exceptions.
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
