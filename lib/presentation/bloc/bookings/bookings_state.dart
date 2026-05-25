import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

sealed class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

final class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

final class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

final class BookingsLoaded extends BookingsState {
  const BookingsLoaded({
    required this.bookings,
    required this.selectedTab,
  });

  final List<BookingEntity> bookings;
  final BookingTab selectedTab;

  List<BookingEntity> get activeBookings =>
      bookings.where((booking) => booking.tab == BookingTab.active).toList();

  List<BookingEntity> get upcomingBookings =>
      bookings.where((booking) => booking.tab == BookingTab.upcoming).toList();

  List<BookingEntity> get historyBookings =>
      bookings.where((booking) => booking.tab == BookingTab.history).toList();

  List<BookingEntity> get visibleBookings => switch (selectedTab) {
        BookingTab.active => activeBookings,
        BookingTab.upcoming => upcomingBookings,
        BookingTab.history => historyBookings,
      };

  BookingsLoaded copyWith({
    List<BookingEntity>? bookings,
    BookingTab? selectedTab,
  }) {
    return BookingsLoaded(
      bookings: bookings ?? this.bookings,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [bookings, selectedTab];
}

final class BookingsFailure extends BookingsState {
  const BookingsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
