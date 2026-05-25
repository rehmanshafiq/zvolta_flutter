import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_event.dart';
import 'package:zvolta_flutter/presentation/widgets/app_bottom_nav_bar.dart';

/// Shell scaffold wrapping [StatefulNavigationShell].
///
/// Navigation ownership: **GoRouter** is the single source of truth.
/// [BottomNavBloc] only mirrors [navigationShell.currentIndex] for UI state.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BottomNavBloc>(),
      child: _MainShellView(navigationShell: navigationShell),
    );
  }
}

class _MainShellView extends StatefulWidget {
  const _MainShellView({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<_MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<_MainShellView> {
  @override
  void initState() {
    super.initState();
    _mirrorRouterIndexToBloc();
  }

  @override
  void didUpdateWidget(covariant _MainShellView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      _mirrorRouterIndexToBloc();
    }
  }

  /// One-way sync: GoRouter → Bloc (never triggers routing).
  void _mirrorRouterIndexToBloc() {
    context.read<BottomNavBloc>().add(
          BottomNavIndexChanged(widget.navigationShell.currentIndex),
        );
  }

  void _onItemSelected(int index) {
    if (index == widget.navigationShell.currentIndex) return;

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // GoRouter index drives highlight; Bloc stays in sync via lifecycle hooks.
    final selectedIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
