import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/home_dashboard_entity.dart';
import 'package:zvolta_flutter/domain/repositories/home_repository.dart';

/// Loads dashboard summary, weather, and recent charges for the home screen.
class GetHomeDashboardUseCase implements UseCase<HomeDashboardEntity, NoParams> {
  GetHomeDashboardUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<HomeDashboardEntity>> call(NoParams params) {
    return _repository.getHomeDashboard();
  }
}
