import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';
import 'package:zvolta_flutter/domain/usecases/get_wallet_dashboard_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/wallet/wallet_event.dart';
import 'package:zvolta_flutter/presentation/bloc/wallet/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({required GetWalletDashboardUseCase getWalletDashboardUseCase})
      : _getWalletDashboardUseCase = getWalletDashboardUseCase,
        super(const WalletInitial()) {
    on<WalletRequested>(_onRequested);
    on<WalletRefreshRequested>(_onRequested);
    on<WalletTabChanged>(_onTabChanged);
    on<WalletPromoApplied>(_onPromoApplied);
  }

  final GetWalletDashboardUseCase _getWalletDashboardUseCase;

  Future<void> _onRequested(
    WalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    final current = state;
    final selectedTab =
        current is WalletLoaded ? current.selectedTab : WalletSectionTab.wallet;

    if (current is! WalletLoaded) {
      emit(const WalletLoading());
    }

    final result = await _getWalletDashboardUseCase(const NoParams());

    if (result.isError) {
      emit(WalletFailure(message: result.failureOrNull!.message));
      return;
    }

    emit(
      WalletLoaded(
        dashboard: result.dataOrNull!,
        selectedTab: selectedTab,
      ),
    );
  }

  void _onTabChanged(
    WalletTabChanged event,
    Emitter<WalletState> emit,
  ) {
    final current = state;
    if (current is! WalletLoaded) return;
    emit(current.copyWith(selectedTab: event.tab));
  }

  void _onPromoApplied(
    WalletPromoApplied event,
    Emitter<WalletState> emit,
  ) {
    // Promo validation will be wired to backend later.
  }
}
