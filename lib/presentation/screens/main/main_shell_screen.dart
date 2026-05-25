import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_event.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_state.dart';

/// Shell scaffold with bottom navigation, driven by [BottomNavBloc].
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

class _MainShellView extends StatelessWidget {
  const _MainShellView({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onDestinationSelected(BuildContext context, int index) {
    context.read<BottomNavBloc>().add(BottomNavIndexChanged(index));
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomNavBloc, BottomNavState>(
      listenWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      listener: (context, state) {
        if (navigationShell.currentIndex != state.currentIndex) {
          navigationShell.goBranch(state.currentIndex);
        }
      },
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) =>
                  _onDestinationSelected(context, index),
              destinations: _destinations,
            ),
          );
        },
      ),
    );
  }
}
