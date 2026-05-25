import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';

class RecentChargeModel {
  const RecentChargeModel({
    required this.stationName,
    required this.timeAgo,
    required this.costPerUnitPkr,
    required this.totalCostPkr,
    required this.energyKwh,
  });

  final String stationName;
  final String timeAgo;
  final int costPerUnitPkr;
  final double totalCostPkr;
  final double energyKwh;

  RecentChargeEntity toEntity() {
    return RecentChargeEntity(
      stationName: stationName,
      timeAgo: timeAgo,
      costPerUnitPkr: costPerUnitPkr,
      totalCostPkr: totalCostPkr,
      energyKwh: energyKwh,
    );
  }
}
