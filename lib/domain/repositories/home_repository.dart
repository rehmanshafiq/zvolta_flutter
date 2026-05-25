import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/domain/entities/home_dashboard_entity.dart';

/// Contract for home dashboard data operations.
abstract class HomeRepository {
  Future<Result<HomeDashboardEntity>> getHomeDashboard();
}
