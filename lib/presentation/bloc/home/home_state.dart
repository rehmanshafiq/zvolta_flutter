import 'package:equatable/equatable.dart';
import 'package:zvolta_flutter/domain/entities/user_entity.dart';

/// Immutable states for [HomeBloc].
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.users});

  final List<UserEntity> users;

  @override
  List<Object?> get props => [users];
}

final class HomeFailure extends HomeState {
  const HomeFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
