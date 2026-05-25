import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';
import 'package:zvolta_flutter/domain/usecases/get_bookings_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/bookings/bookings_event.dart';
import 'package:zvolta_flutter/presentation/bloc/bookings/bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc({required GetBookingsUseCase getBookingsUseCase})
      : _getBookingsUseCase = getBookingsUseCase,
        super(const BookingsInitial()) {
    on<BookingsRequested>(_onRequested);
    on<BookingsRefreshRequested>(_onRequested);
    on<BookingsTabChanged>(_onTabChanged);
    on<BookingCancelled>(_onBookingCancelled);
  }

  final GetBookingsUseCase _getBookingsUseCase;

  Future<void> _onRequested(
    BookingsEvent event,
    Emitter<BookingsState> emit,
  ) async {
    final current = state;
    final selectedTab =
        current is BookingsLoaded ? current.selectedTab : BookingTab.active;

    if (current is! BookingsLoaded) {
      emit(const BookingsLoading());
    }

    final result = await _getBookingsUseCase(const NoParams());

    if (result.isError) {
      emit(BookingsFailure(message: result.failureOrNull!.message));
      return;
    }

    final bookings = result.dataOrNull ?? [];
    final filteredBookings = current is BookingsLoaded
        ? _mergeCancelledBookings(current.bookings, bookings)
        : bookings;

    emit(
      BookingsLoaded(
        bookings: filteredBookings,
        selectedTab: selectedTab,
      ),
    );
  }

  void _onTabChanged(
    BookingsTabChanged event,
    Emitter<BookingsState> emit,
  ) {
    final current = state;
    if (current is! BookingsLoaded) return;
    emit(current.copyWith(selectedTab: event.tab));
  }

  void _onBookingCancelled(
    BookingCancelled event,
    Emitter<BookingsState> emit,
  ) {
    final current = state;
    if (current is! BookingsLoaded) return;

    final updated = current.bookings
        .where((booking) => booking.id != event.bookingId)
        .toList();

    emit(current.copyWith(bookings: updated));
  }

  List<BookingEntity> _mergeCancelledBookings(
    List<BookingEntity> currentBookings,
    List<BookingEntity> fetchedBookings,
  ) {
    final removedIds = currentBookings
        .where(
          (booking) => !fetchedBookings.any((item) => item.id == booking.id),
        )
        .map((booking) => booking.id)
        .toSet();

    return fetchedBookings
        .where((booking) => !removedIds.contains(booking.id))
        .toList();
  }
}
