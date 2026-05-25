import 'package:equatable/equatable.dart';

/// Events for the home dashboard screen.
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeDashboardRequested extends HomeEvent {
  const HomeDashboardRequested();
}

final class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}
