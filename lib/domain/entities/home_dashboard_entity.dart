import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';

/// Aggregated home dashboard data for the presentation layer.
class HomeDashboardEntity extends Equatable {
  const HomeDashboardEntity({
    required this.lastChargeKwh,
    required this.lastChargeTimeAgo,
    required this.co2ReducedKg,
    required this.weatherCondition,
    required this.temperatureCelsius,
    required this.city,
    required this.rangeImpactKm,
    required this.recentCharges,
  });

  final double lastChargeKwh;
  final String lastChargeTimeAgo;
  final int co2ReducedKg;
  final String weatherCondition;
  final int temperatureCelsius;
  final String city;
  final int rangeImpactKm;
  final List<RecentChargeEntity> recentCharges;

  @override
  List<Object?> get props => [
        lastChargeKwh,
        lastChargeTimeAgo,
        co2ReducedKg,
        weatherCondition,
        temperatureCelsius,
        city,
        rangeImpactKm,
        recentCharges,
      ];
}
