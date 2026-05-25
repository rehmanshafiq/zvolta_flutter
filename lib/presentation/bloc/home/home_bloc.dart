import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_event.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_state.dart';

/// Manages home dashboard data fetching via use cases.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetHomeDashboardUseCase getHomeDashboardUseCase})
      : _getHomeDashboardUseCase = getHomeDashboardUseCase,
        super(const HomeInitial()) {
    on<HomeDashboardRequested>(_onDashboardRequested);
    on<HomeRefreshRequested>(_onDashboardRequested);
  }

  final GetHomeDashboardUseCase _getHomeDashboardUseCase;

  Future<void> _onDashboardRequested(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await _getHomeDashboardUseCase(const NoParams());

    if (result.isError) {
      emit(HomeFailure(message: result.failureOrNull!.message));
      return;
    }

    final dashboard = result.dataOrNull;
    if (dashboard == null) {
      emit(const HomeFailure(message: 'Unable to load home dashboard'));
      return;
    }

    emit(HomeLoaded(dashboard: dashboard));
  }
}
