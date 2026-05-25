import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/app_init_status.dart';
import 'package:zvolta_flutter/domain/repositories/app_repository.dart';

/// Checks whether the app has completed its startup initialization.
class CheckAppInitializedUseCase
    implements UseCase<AppInitStatus, NoParams> {
  CheckAppInitializedUseCase(this._repository);

  final AppRepository _repository;

  @override
  Future<Result<AppInitStatus>> call(NoParams params) {
    return _repository.checkAppInitialized();
  }
}
