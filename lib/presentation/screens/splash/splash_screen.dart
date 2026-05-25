import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zvolta_flutter/core/constants/app_constants.dart';
import 'package:zvolta_flutter/core/constants/route_constants.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/presentation/bloc/splash/splash_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/splash/splash_event.dart';
import 'package:zvolta_flutter/presentation/bloc/splash/splash_state.dart';
import 'package:zvolta_flutter/presentation/widgets/app_error_view.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';

/// Initial screen shown while the app initializes.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashBloc>()..add(const SplashStarted()),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashReady) {
            context.go(RouteConstants.home);
          }
        },
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            return switch (state) {
              SplashFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context
                      .read<SplashBloc>()
                      .add(const SplashRetryRequested()),
                ),
              _ => const _SplashContent(),
            };
          },
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bolt,
            size: 72,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 32),
          const AppLoadingIndicator(message: 'Loading...'),
        ],
      ),
    );
  }
}
