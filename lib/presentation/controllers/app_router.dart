import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zvolta_flutter/core/constants/route_constants.dart';
import 'package:zvolta_flutter/presentation/screens/explore/explore_screen.dart';
import 'package:zvolta_flutter/presentation/screens/home/home_screen.dart';
import 'package:zvolta_flutter/presentation/screens/main/main_shell_screen.dart';
import 'package:zvolta_flutter/presentation/screens/profile/profile_screen.dart';
import 'package:zvolta_flutter/presentation/screens/splash/splash_screen.dart';

/// Global navigator key for GoRouter.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Application router configuration.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteConstants.splash,
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.explore,
                name: 'explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
