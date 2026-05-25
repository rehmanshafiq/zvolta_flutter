import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_event.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_state.dart';

/// Mirrors the active bottom-nav index for UI consumers.
/// Does not perform navigation — GoRouter owns routing.
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(currentIndex: 0)) {
    on<BottomNavIndexChanged>(_onIndexChanged);
  }

  void _onIndexChanged(
    BottomNavIndexChanged event,
    Emitter<BottomNavState> emit,
  ) {
    if (event.index < 0 || event.index >= BottomNavTab.values.length) {
      return;
    }
    if (event.index == state.currentIndex) return;
    emit(state.copyWith(currentIndex: event.index));
  }
}
