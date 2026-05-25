import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

sealed class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

final class BookingsRequested extends BookingsEvent {
  const BookingsRequested();
}

final class BookingsRefreshRequested extends BookingsEvent {
  const BookingsRefreshRequested();
}

final class BookingsTabChanged extends BookingsEvent {
  const BookingsTabChanged(this.tab);

  final BookingTab tab;

  @override
  List<Object?> get props => [tab];
}

final class BookingCancelled extends BookingsEvent {
  const BookingCancelled(this.bookingId);

  final String bookingId;

  @override
  List<Object?> get props => [bookingId];
}
