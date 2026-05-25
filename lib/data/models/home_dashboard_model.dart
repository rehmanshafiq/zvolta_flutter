import 'package:zvolta_flutter/data/models/recent_charge_model.dart';
import 'package:zvolta_flutter/domain/entities/home_dashboard_entity.dart';

class HomeDashboardModel {
  const HomeDashboardModel({
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
  final List<RecentChargeModel> recentCharges;

  HomeDashboardEntity toEntity() {
    return HomeDashboardEntity(
      lastChargeKwh: lastChargeKwh,
      lastChargeTimeAgo: lastChargeTimeAgo,
      co2ReducedKg: co2ReducedKg,
      weatherCondition: weatherCondition,
      temperatureCelsius: temperatureCelsius,
      city: city,
      rangeImpactKm: rangeImpactKm,
      recentCharges: recentCharges.map((charge) => charge.toEntity()).toList(),
    );
  }
}
