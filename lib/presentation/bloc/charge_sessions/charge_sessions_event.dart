import 'package:equatable/equatable.dart';

sealed class ChargeSessionsEvent extends Equatable {
  const ChargeSessionsEvent();

  @override
  List<Object?> get props => [];
}

final class ChargeSessionsRequested extends ChargeSessionsEvent {
  const ChargeSessionsRequested();
}

final class ChargeSessionsRefreshRequested extends ChargeSessionsEvent {
  const ChargeSessionsRefreshRequested();
}
