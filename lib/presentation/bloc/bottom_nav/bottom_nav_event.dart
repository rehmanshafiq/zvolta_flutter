import 'package:equatable/equatable.dart';

/// Bottom navigation tab identifiers.
enum BottomNavTab {
  home,
  map,
  bookings,
  wallet,
  profile,
}

/// Events for [BottomNavBloc].
sealed class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object?> get props => [];
}

/// Mirrors [StatefulNavigationShell.currentIndex] into Bloc state.
/// Must never trigger routing — navigation is owned by GoRouter.
final class BottomNavIndexChanged extends BottomNavEvent {
  const BottomNavIndexChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
