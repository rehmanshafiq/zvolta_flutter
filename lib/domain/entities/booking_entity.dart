import 'package:equatable/equatable.dart';

enum BookingTab { active, upcoming, history }

enum BookingStatus { charging, reserved, completed }

/// A charging booking shown on the bookings screen.
class BookingEntity extends Equatable {
  const BookingEntity({
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

  String get statusLabel => switch (status) {
        BookingStatus.charging => 'Charging',
        BookingStatus.reserved => 'Reserved',
        BookingStatus.completed => 'Completed',
      };

  @override
  List<Object?> get props => [
        id,
        stationName,
        stationSubtitle,
        tab,
        status,
        dateTime,
        timeAgo,
        durationMinutes,
        estimatedCostPkr,
        totalCostPkr,
        energyKwh,
        chargeSessionId,
      ];
}
