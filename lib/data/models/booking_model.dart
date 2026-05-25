import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

class BookingModel {
  const BookingModel({
    required this.id,
    required this.stationName,
    required this.stationSubtitle,
    required this.tab,
    required this.status,
    required this.dateTime,
    this.timeAgo,
    this.durationMinutes,
    this.estimatedCostPkr,
    this.totalCostPkr,
    this.energyKwh,
    this.chargeSessionId,
  });

  final String id;
  final String stationName;
  final String stationSubtitle;
  final BookingTab tab;
  final BookingStatus status;
  final DateTime dateTime;
  final String? timeAgo;
  final int? durationMinutes;
  final double? estimatedCostPkr;
  final double? totalCostPkr;
  final double? energyKwh;
  final String? chargeSessionId;

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      stationName: stationName,
      stationSubtitle: stationSubtitle,
      tab: tab,
      status: status,
      dateTime: dateTime,
      timeAgo: timeAgo,
      durationMinutes: durationMinutes,
      estimatedCostPkr: estimatedCostPkr,
      totalCostPkr: totalCostPkr,
      energyKwh: energyKwh,
      chargeSessionId: chargeSessionId,
    );
  }
}
