import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/core/constants/route_constants.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/domain/entities/home_dashboard_entity.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_event.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_state.dart';
import 'package:zvolta_flutter/presentation/widgets/app_error_view.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_quick_action_button.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_recent_charge_card.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_summary_stat_card.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_weather_range_card.dart';

/// Home tab — EV charging dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeDashboardRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return switch (state) {
              HomeInitial() || HomeLoading() => const AppLoadingIndicator(
                  message: 'Loading dashboard...',
                ),
              HomeFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context
                      .read<HomeBloc>()
                      .add(const HomeRefreshRequested()),
                ),
              HomeLoaded(:final dashboard) => RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const HomeRefreshRequested());
                    await context.read<HomeBloc>().stream.firstWhere(
                          (s) => s is HomeLoaded || s is HomeFailure,
                        );
                  },
                  child: _HomeContent(dashboard: dashboard),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.dashboard});

  final HomeDashboardEntity dashboard;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: HomeSummaryStatCard(
                icon: Icons.bolt,
                title: 'Last Charge',
                value:
                    '${dashboard.lastChargeKwh.toStringAsFixed(2)} kWh, ${dashboard.lastChargeTimeAgo}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HomeSummaryStatCard(
                icon: Icons.eco_outlined,
                title: 'CO₂ Reduced',
                value: '${dashboard.co2ReducedKg} kg',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HomeWeatherRangeCard(
          weatherCondition: dashboard.weatherCondition,
          temperatureCelsius: dashboard.temperatureCelsius,
          city: dashboard.city,
          rangeImpactKm: dashboard.rangeImpactKm,
        ),
        const SizedBox(height: 24),
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: HomeQuickActionButton(
                icon: Icons.location_on_outlined,
                label: 'Find Charger',
                onTap: () => context.go(RouteConstants.map),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HomeQuickActionButton(
                icon: Icons.calendar_today_outlined,
                label: 'My Bookings',
                onTap: () => context.go(RouteConstants.bookings),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent Charges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.push(RouteConstants.chargeSessions),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.homeIconGreen,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...dashboard.recentCharges.map(
          (charge) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HomeRecentChargeCard(charge: charge),
          ),
        ),
      ],
    );
  }
}
