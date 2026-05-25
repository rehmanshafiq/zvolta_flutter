import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/core/errors/failures.dart';

/// Lightweight result type used across repositories and use cases.
/// Avoids adding extra packages like dartz while keeping call sites explicit.
sealed class Result<T> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final data) => data,
        Error<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Error<T>(:final failure) => failure,
      };

  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success<T>(:final data) => Success(transform(data)),
        Error<T>(:final failure) => Error(failure),
      };

  Future<Result<R>> asyncMap<R>(Future<R> Function(T data) transform) async =>
      switch (this) {
        Success<T>(:final data) => Success(await transform(data)),
        Error<T>(:final failure) => Error(failure),
      };
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
