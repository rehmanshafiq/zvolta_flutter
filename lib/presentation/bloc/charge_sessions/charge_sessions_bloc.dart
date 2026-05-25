import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/usecases/get_charge_sessions_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/charge_sessions/charge_sessions_event.dart';
import 'package:zvolta_flutter/presentation/bloc/charge_sessions/charge_sessions_state.dart';

class ChargeSessionsBloc extends Bloc<ChargeSessionsEvent, ChargeSessionsState> {
  ChargeSessionsBloc({required GetChargeSessionsUseCase getChargeSessionsUseCase})
      : _getChargeSessionsUseCase = getChargeSessionsUseCase,
        super(const ChargeSessionsInitial()) {
    on<ChargeSessionsRequested>(_onRequested);
    on<ChargeSessionsRefreshRequested>(_onRequested);
  }

  final GetChargeSessionsUseCase _getChargeSessionsUseCase;

  Future<void> _onRequested(
    ChargeSessionsEvent event,
    Emitter<ChargeSessionsState> emit,
  ) async {
    emit(const ChargeSessionsLoading());

    final result = await _getChargeSessionsUseCase(const NoParams());

    if (result.isError) {
      emit(ChargeSessionsFailure(message: result.failureOrNull!.message));
      return;
    }

    emit(ChargeSessionsLoaded(sessions: result.dataOrNull ?? []));
  }
}
