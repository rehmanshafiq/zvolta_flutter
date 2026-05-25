import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/core/utils/result.dart';

/// Base contract for all use cases.
/// Each use case encapsulates a single business action.
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Use when a use case does not require input parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
