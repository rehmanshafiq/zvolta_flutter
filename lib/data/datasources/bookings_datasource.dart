import 'package:zvolta_flutter/data/models/booking_model.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

/// Local data source for bookings.
abstract class BookingsLocalDataSource {
  Future<List<BookingModel>> getBookings();
}

class BookingsLocalDataSourceImpl implements BookingsLocalDataSource {
  @override
  Future<List<BookingModel>> getBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return [
      BookingModel(
        id: 'upcoming-1',
        stationName: 'ZVolta Head Office - 7KW',
        stationSubtitle: '7 KW · ZVolta',
        tab: BookingTab.upcoming,
        status: BookingStatus.reserved,
        dateTime: DateTime(2026, 5, 25, 17, 30),
        durationMinutes: 15,
        estimatedCostPkr: 0,
      ),
      BookingModel(
        id: 'history-1',
        stationName: 'Vlektra Station 1',
        stationSubtitle: 'Vlektra Station 1',
        tab: BookingTab.history,
        status: BookingStatus.completed,
        dateTime: DateTime(2026, 5, 22, 21, 26, 33),
        timeAgo: '2 days ago',
        totalCostPkr: 0,
        energyKwh: 0.46,
        chargeSessionId: '947',
      ),
      BookingModel(
        id: 'history-2',
        stationName: 'Vlektra Station 2',
        stationSubtitle: 'Vlektra Station 2',
        tab: BookingTab.history,
        status: BookingStatus.completed,
        dateTime: DateTime(2026, 5, 14, 23, 15, 4),
        timeAgo: '1 week ago',
        totalCostPkr: 1,
        energyKwh: 0.12,
        chargeSessionId: '948',
      ),
    ];
  }
}
