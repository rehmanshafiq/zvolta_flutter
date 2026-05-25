import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_event.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_state.dart';

/// Manages the currently selected bottom navigation tab.
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc()
      : super(const BottomNavState(currentTab: BottomNavTab.home)) {
    on<BottomNavTabChanged>(_onTabChanged);
    on<BottomNavIndexChanged>(_onIndexChanged);
  }

  void _onTabChanged(
    BottomNavTabChanged event,
    Emitter<BottomNavState> emit,
  ) {
    emit(state.copyWith(currentTab: event.tab));
  }

  void _onIndexChanged(
    BottomNavIndexChanged event,
    Emitter<BottomNavState> emit,
  ) {
    final tabs = BottomNavTab.values;
    if (event.index < 0 || event.index >= tabs.length) return;
    emit(state.copyWith(currentTab: tabs[event.index]));
  }
}
