import 'package:equatable/equatable.dart';

/// Immutable UI state for bottom navigation highlight.
/// [currentIndex] is mirrored from GoRouter — not a navigation driver.
final class BottomNavState extends Equatable {
  const BottomNavState({required this.currentIndex});

  final int currentIndex;

  BottomNavState copyWith({int? currentIndex}) {
    return BottomNavState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
