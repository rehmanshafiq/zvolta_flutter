import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';

/// Contract for charge session history.
abstract class ChargeSessionsRepository {
  Future<Result<List<RecentChargeEntity>>> getChargeSessions();
}
