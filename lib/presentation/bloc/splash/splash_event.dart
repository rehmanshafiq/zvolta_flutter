import 'package:equatable/equatable.dart';

/// Events dispatched to [SplashBloc].
sealed class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the splash screen is first shown.
final class SplashStarted extends SplashEvent {
  const SplashStarted();
}

/// Retry initialization after a failure.
final class SplashRetryRequested extends SplashEvent {
  const SplashRetryRequested();
}
