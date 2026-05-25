import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';
import 'package:zvolta_flutter/presentation/bloc/bookings/bookings_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/bookings/bookings_event.dart';
import 'package:zvolta_flutter/presentation/bloc/bookings/bookings_state.dart';
import 'package:zvolta_flutter/presentation/widgets/app_error_view.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';
import 'package:zvolta_flutter/presentation/widgets/bookings/bookings_empty_state.dart';
import 'package:zvolta_flutter/presentation/widgets/bookings/bookings_scan_button.dart';
import 'package:zvolta_flutter/presentation/widgets/bookings/bookings_tab_bar.dart';
import 'package:zvolta_flutter/presentation/widgets/bookings/charging_receipt_bottom_sheet.dart';
import 'package:zvolta_flutter/presentation/widgets/bookings/history_booking_card.dart';
import 'package:zvolta_flutter/presentation/widgets/bookings/upcoming_booking_card.dart';

/// Bookings tab — active, upcoming, and history sessions.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingsBloc>()..add(const BookingsRequested()),
      child: const _BookingsView(),
    );
  }
}

class _BookingsView extends StatelessWidget {
  const _BookingsView();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            return switch (state) {
              BookingsInitial() || BookingsLoading() =>
                const AppLoadingIndicator(message: 'Loading bookings...'),
              BookingsFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context
                      .read<BookingsBloc>()
                      .add(const BookingsRefreshRequested()),
                ),
              BookingsLoaded() => RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<BookingsBloc>()
                        .add(const BookingsRefreshRequested());
                    await context.read<BookingsBloc>().stream.firstWhere(
                          (s) => s is BookingsLoaded || s is BookingsFailure,
                        );
                  },
                  child: _BookingsContent(
                    state: state,
                    onScanTap: () => _showSnackBar(context, 'Opening scanner...'),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _BookingsContent extends StatelessWidget {
  const _BookingsContent({
    required this.state,
    required this.onScanTap,
  });

  final BookingsLoaded state;
  final VoidCallback onScanTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingsBloc>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        BookingsScanButton(onTap: onScanTap),
        const SizedBox(height: 16),
        BookingsTabBar(
          selectedTab: state.selectedTab,
          onTabChanged: (tab) => bloc.add(BookingsTabChanged(tab)),
        ),
        const SizedBox(height: 16),
        ...switch (state.selectedTab) {
          BookingTab.active => [
              if (state.activeBookings.isEmpty)
                const BookingsEmptyState(
                  title: 'No Active Sessions',
                  subtitle: "You don't have any active charging sessions",
                )
              else
                ...state.activeBookings.map(
                  (booking) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: HistoryBookingCard(
                      booking: booking,
                      onReceiptTap: () {},
                    ),
                  ),
                ),
            ],
          BookingTab.upcoming => [
              if (state.upcomingBookings.isEmpty)
                const BookingsEmptyState(
                  title: 'No Upcoming Bookings',
                  subtitle: "You don't have any upcoming reservations",
                  icon: Icons.event_outlined,
                )
              else
                ...state.upcomingBookings.map(
                  (booking) => UpcomingBookingCard(
                    booking: booking,
                    onScanTap: onScanTap,
                    onModifyTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Modify ${booking.stationName}')),
                      );
                    },
                    onCancelTap: () {
                      bloc.add(BookingCancelled(booking.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking cancelled')),
                      );
                    },
                  ),
                ),
            ],
          BookingTab.history => [
              if (state.historyBookings.isEmpty)
                const BookingsEmptyState(
                  title: 'No History',
                  subtitle: 'Your completed sessions will appear here',
                  icon: Icons.history_rounded,
                )
              else
                ...state.historyBookings.map(
                  (booking) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: HistoryBookingCard(
                      booking: booking,
                      onReceiptTap: () {
                        ChargingReceiptBottomSheet.show(context, booking);
                      },
                    ),
                  ),
                ),
            ],
        },
      ],
    );
  }
}
