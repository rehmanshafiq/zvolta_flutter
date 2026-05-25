import 'package:equatable/equatable.dart';

/// A single recent charging session shown on the home screen.
class RecentChargeEntity extends Equatable {
  const RecentChargeEntity({
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

  @override
  List<Object?> get props => [
        stationName,
        timeAgo,
        costPerUnitPkr,
        totalCostPkr,
        energyKwh,
      ];
}
