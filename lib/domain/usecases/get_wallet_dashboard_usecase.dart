import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';
import 'package:zvolta_flutter/domain/repositories/wallet_repository.dart';

class GetWalletDashboardUseCase
    implements UseCase<WalletDashboardEntity, NoParams> {
  GetWalletDashboardUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletDashboardEntity>> call(NoParams params) {
    return _repository.getWalletDashboard();
  }
}
