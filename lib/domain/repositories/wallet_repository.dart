import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<Result<WalletDashboardEntity>> getWalletDashboard();
}
