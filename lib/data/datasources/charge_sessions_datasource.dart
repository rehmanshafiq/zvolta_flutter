import 'package:zvolta_flutter/data/models/recent_charge_model.dart';

/// Local data source for charge session history.
abstract class ChargeSessionsLocalDataSource {
  Future<List<RecentChargeModel>> getChargeSessions();
}

class ChargeSessionsLocalDataSourceImpl
    implements ChargeSessionsLocalDataSource {
  @override
  Future<List<RecentChargeModel>> getChargeSessions() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return const [
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
      RecentChargeModel(
        stationName: 'Vlektra Station 3',
        timeAgo: '2 weeks ago',
        costPerUnitPkr: 50,
        totalCostPkr: 5.75,
        energyKwh: 0.57,
      ),
      RecentChargeModel(
        stationName: 'Vlektra Station 4',
        timeAgo: '3 weeks ago',
        costPerUnitPkr: 50,
        totalCostPkr: 6.25,
        energyKwh: 0.60,
      ),
      RecentChargeModel(
        stationName: 'Vlektra Station 5',
        timeAgo: '1 month ago',
        costPerUnitPkr: 50,
        totalCostPkr: 5.50,
        energyKwh: 0.57,
      ),
      RecentChargeModel(
        stationName: 'Vlektra Station 6',
        timeAgo: '1 month ago',
        costPerUnitPkr: 50,
        totalCostPkr: 3,
        energyKwh: 0.44,
      ),
      RecentChargeModel(
        stationName: 'Vlektra Station 7',
        timeAgo: '2 months ago',
        costPerUnitPkr: 50,
        totalCostPkr: 9.50,
        energyKwh: 0.53,
      ),
      RecentChargeModel(
        stationName: 'Vlektra Station 8',
        timeAgo: '3 months ago',
        costPerUnitPkr: 50,
        totalCostPkr: 10.50,
        energyKwh: 0.46,
      ),
    ];
  }
}
