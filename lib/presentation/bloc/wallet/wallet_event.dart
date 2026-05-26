import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

final class WalletRequested extends WalletEvent {
  const WalletRequested();
}

final class WalletRefreshRequested extends WalletEvent {
  const WalletRefreshRequested();
}

final class WalletTabChanged extends WalletEvent {
  const WalletTabChanged(this.tab);

  final WalletSectionTab tab;

  @override
  List<Object?> get props => [tab];
}

final class WalletPromoApplied extends WalletEvent {
  const WalletPromoApplied(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
