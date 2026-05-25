import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';
import 'package:zvolta_flutter/domain/repositories/bookings_repository.dart';

/// Loads bookings for all tabs.
class GetBookingsUseCase implements UseCase<List<BookingEntity>, NoParams> {
  GetBookingsUseCase(this._repository);

  final BookingsRepository _repository;

  @override
  Future<Result<List<BookingEntity>>> call(NoParams params) {
    return _repository.getBookings();
  }
}
