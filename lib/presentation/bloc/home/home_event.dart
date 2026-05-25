import 'package:equatable/equatable.dart';

/// Events for the home screen user list.
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeUsersRequested extends HomeEvent {
  const HomeUsersRequested();
}

final class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}
