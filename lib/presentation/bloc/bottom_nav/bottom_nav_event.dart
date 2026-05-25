import 'package:equatable/equatable.dart';

/// Bottom navigation tab identifiers.
enum BottomNavTab {
  home,
  explore,
  profile,
}

/// Events for [BottomNavBloc].
sealed class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object?> get props => [];
}

final class BottomNavTabChanged extends BottomNavEvent {
  const BottomNavTabChanged(this.tab);

  final BottomNavTab tab;

  @override
  List<Object?> get props => [tab];
}

final class BottomNavIndexChanged extends BottomNavEvent {
  const BottomNavIndexChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
