import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

final class WalletLoading extends WalletState {
  const WalletLoading();
}

final class WalletLoaded extends WalletState {
  const WalletLoaded({
    required this.dashboard,
    required this.selectedTab,
  });

  final WalletDashboardEntity dashboard;
  final WalletSectionTab selectedTab;

  WalletLoaded copyWith({
    WalletDashboardEntity? dashboard,
    WalletSectionTab? selectedTab,
  }) {
    return WalletLoaded(
      dashboard: dashboard ?? this.dashboard,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [dashboard, selectedTab];
}

final class WalletFailure extends WalletState {
  const WalletFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
