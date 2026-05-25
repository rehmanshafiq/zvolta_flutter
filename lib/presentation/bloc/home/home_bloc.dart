import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/usecases/get_users_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_event.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_state.dart';

/// Manages home screen data fetching via use cases.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetUsersUseCase getUsersUseCase})
      : _getUsersUseCase = getUsersUseCase,
        super(const HomeInitial()) {
    on<HomeUsersRequested>(_onUsersRequested);
    on<HomeRefreshRequested>(_onUsersRequested);
  }

  final GetUsersUseCase _getUsersUseCase;

  Future<void> _onUsersRequested(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await _getUsersUseCase(const NoParams());

    if (result.isError) {
      emit(HomeFailure(message: result.failureOrNull!.message));
      return;
    }

    emit(HomeLoaded(users: result.dataOrNull ?? []));
  }
}
