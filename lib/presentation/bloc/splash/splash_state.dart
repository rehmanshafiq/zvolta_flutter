import 'package:equatable/equatable.dart';

/// Immutable states for [SplashBloc].
sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashLoading extends SplashState {
  const SplashLoading();
}

final class SplashReady extends SplashState {
  const SplashReady({this.isFirstLaunch = false});

  final bool isFirstLaunch;

  @override
  List<Object?> get props => [isFirstLaunch];
}

final class SplashFailure extends SplashState {
  const SplashFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
