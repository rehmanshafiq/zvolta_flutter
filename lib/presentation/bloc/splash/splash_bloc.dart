import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/constants/app_constants.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/usecases/check_app_initialized_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/splash/splash_event.dart';
import 'package:zvolta_flutter/presentation/bloc/splash/splash_state.dart';

/// Handles splash screen initialization logic.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({required CheckAppInitializedUseCase checkAppInitializedUseCase})
      : _checkAppInitializedUseCase = checkAppInitializedUseCase,
        super(const SplashInitial()) {
    on<SplashStarted>(_onStarted);
    on<SplashRetryRequested>(_onStarted);
  }

  final CheckAppInitializedUseCase _checkAppInitializedUseCase;

  Future<void> _onStarted(
    SplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());

    // Minimum splash duration for branding
    await Future<void>.delayed(AppConstants.splashDuration);

    final result = await _checkAppInitializedUseCase(const NoParams());

    if (result.isError) {
      emit(SplashFailure(message: result.failureOrNull!.message));
      return;
    }

    final status = result.dataOrNull;
    if (status == null) {
      emit(const SplashFailure(message: 'Unable to initialize the app'));
      return;
    }

    emit(SplashReady(isFirstLaunch: status.isFirstLaunch));
  }
}
