import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';
import 'package:zvolta_flutter/domain/repositories/charge_sessions_repository.dart';

/// Loads the full charge session history.
class GetChargeSessionsUseCase
    implements UseCase<List<RecentChargeEntity>, NoParams> {
  GetChargeSessionsUseCase(this._repository);

  final ChargeSessionsRepository _repository;

  @override
  Future<Result<List<RecentChargeEntity>>> call(NoParams params) {
    return _repository.getChargeSessions();
  }
}
