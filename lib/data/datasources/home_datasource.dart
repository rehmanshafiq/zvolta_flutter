import 'package:zvolta_flutter/data/models/home_dashboard_model.dart';
import 'package:zvolta_flutter/data/models/recent_charge_model.dart';

/// Local data source for home dashboard content.
/// Replace with remote API when backend is available.
abstract class HomeLocalDataSource {
  Future<HomeDashboardModel> getHomeDashboard();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<HomeDashboardModel> getHomeDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return const HomeDashboardModel(
      lastChargeKwh: 0.46,
      lastChargeTimeAgo: '2 days ago',
      co2ReducedKg: 285,
      weatherCondition: 'Sunny',
      temperatureCelsius: 32,
      city: 'Karachi',
      rangeImpactKm: -8,
      recentCharges: [
        RecentChargeModel(
          stationName: 'Vlektra Station 1',
          timeAgo: '2 days ago',
          costPerUnitPkr: 0,
          totalCostPkr: 0,
          energyKwh: 0.46,
        ),
        RecentChargeModel(
          stationName: 'Vlektra Station 2',
          timeAgo: '1 week ago',
          costPerUnitPkr: 50,
          totalCostPkr: 1,
          energyKwh: 0.12,
        ),
      ],
    );
  }
}
