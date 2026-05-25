import 'package:zvolta_flutter/core/utils/exception_mapper.dart';
import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/data/datasources/bookings_datasource.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';
import 'package:zvolta_flutter/domain/repositories/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  BookingsRepositoryImpl({
    required BookingsLocalDataSource localDataSource,
    ExceptionMapper exceptionMapper = const ExceptionMapper(),
  })  : _localDataSource = localDataSource,
        _exceptionMapper = exceptionMapper;

  final BookingsLocalDataSource _localDataSource;
  final ExceptionMapper _exceptionMapper;

  @override
  Future<Result<List<BookingEntity>>> getBookings() async {
    try {
      final bookings = await _localDataSource.getBookings();
      return Success(bookings.map((booking) => booking.toEntity()).toList());
    } catch (error) {
      return Error(_exceptionMapper.map(error));
    }
  }
}
