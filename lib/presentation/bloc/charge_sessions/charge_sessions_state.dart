import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';

sealed class ChargeSessionsState extends Equatable {
  const ChargeSessionsState();

  @override
  List<Object?> get props => [];
}

final class ChargeSessionsInitial extends ChargeSessionsState {
  const ChargeSessionsInitial();
}

final class ChargeSessionsLoading extends ChargeSessionsState {
  const ChargeSessionsLoading();
}

final class ChargeSessionsLoaded extends ChargeSessionsState {
  const ChargeSessionsLoaded({required this.sessions});

  final List<RecentChargeEntity> sessions;

  int get totalSessions => sessions.length;

  double get totalKwh =>
      sessions.fold(0, (sum, session) => sum + session.energyKwh);

  double get totalSpentPkr =>
      sessions.fold(0, (sum, session) => sum + session.totalCostPkr);

  @override
  List<Object?> get props => [sessions];
}

final class ChargeSessionsFailure extends ChargeSessionsState {
  const ChargeSessionsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
