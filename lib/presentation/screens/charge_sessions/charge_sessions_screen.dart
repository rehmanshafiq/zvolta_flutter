import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/presentation/bloc/charge_sessions/charge_sessions_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/charge_sessions/charge_sessions_event.dart';
import 'package:zvolta_flutter/presentation/bloc/charge_sessions/charge_sessions_state.dart';
import 'package:zvolta_flutter/presentation/widgets/app_error_view.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';
import 'package:zvolta_flutter/presentation/widgets/charge_session_card.dart';
import 'package:zvolta_flutter/presentation/widgets/charge_sessions/charge_sessions_summary_banner.dart';

/// Full charge session history screen.
class ChargeSessionsScreen extends StatelessWidget {
  const ChargeSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChargeSessionsBloc>()..add(const ChargeSessionsRequested()),
      child: const _ChargeSessionsView(),
    );
  }
}

class _ChargeSessionsView extends StatelessWidget {
  const _ChargeSessionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.homeBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.blackColor,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Charge Sessions',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ChargeSessionsBloc, ChargeSessionsState>(
        builder: (context, state) {
          return switch (state) {
            ChargeSessionsInitial() || ChargeSessionsLoading() =>
              const AppLoadingIndicator(message: 'Loading sessions...'),
            ChargeSessionsFailure(:final message) => AppErrorView(
                message: message,
                onRetry: () => context
                    .read<ChargeSessionsBloc>()
                    .add(const ChargeSessionsRefreshRequested()),
              ),
            ChargeSessionsLoaded(:final sessions) => sessions.isEmpty
                ? const _EmptySessionsView()
                : RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<ChargeSessionsBloc>()
                          .add(const ChargeSessionsRefreshRequested());
                      await context.read<ChargeSessionsBloc>().stream.firstWhere(
                            (s) =>
                                s is ChargeSessionsLoaded ||
                                s is ChargeSessionsFailure,
                          );
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: sessions.length + 1,
                      separatorBuilder: (_, index) =>
                          index == 0 ? const SizedBox(height: 16) : const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ChargeSessionsSummaryBanner(
                            totalSessions: state.totalSessions,
                            totalKwh: state.totalKwh,
                            totalSpentPkr: state.totalSpentPkr,
                          );
                        }

                        final session = sessions[index - 1];
                        return ChargeSessionCard(
                          charge: session,
                          showShadow: true,
                        );
                      },
                    ),
                  ),
          };
        },
      ),
    );
  }
}

class _EmptySessionsView extends StatelessWidget {
  const _EmptySessionsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.bottomNavActivePillColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              size: 36,
              color: AppColors.homeIconGreen,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No charge sessions yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your charging history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.homeSubtitleGrey,
            ),
          ),
        ],
      ),
    );
  }
}
