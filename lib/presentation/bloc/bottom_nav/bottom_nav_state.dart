import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_event.dart';

/// Immutable state for bottom navigation.
final class BottomNavState extends Equatable {
  const BottomNavState({required this.currentTab});

  final BottomNavTab currentTab;

  int get currentIndex => BottomNavTab.values.indexOf(currentTab);

  BottomNavState copyWith({BottomNavTab? currentTab}) {
    return BottomNavState(currentTab: currentTab ?? this.currentTab);
  }

  @override
  List<Object?> get props => [currentTab];
}
