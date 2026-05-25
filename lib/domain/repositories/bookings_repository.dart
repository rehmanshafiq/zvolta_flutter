import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

/// Contract for user bookings.
abstract class BookingsRepository {
  Future<Result<List<BookingEntity>>> getBookings();
}
