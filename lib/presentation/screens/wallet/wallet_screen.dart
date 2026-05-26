import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';
import 'package:zvolta_flutter/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/wallet/wallet_event.dart';
import 'package:zvolta_flutter/presentation/bloc/wallet/wallet_state.dart';
import 'package:zvolta_flutter/presentation/widgets/app_error_view.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';
import 'package:zvolta_flutter/presentation/widgets/bookings/charging_receipt_bottom_sheet.dart';
import 'package:zvolta_flutter/presentation/widgets/wallet/wallet_header.dart';
import 'package:zvolta_flutter/presentation/widgets/wallet/wallet_history_transaction_card.dart';
import 'package:zvolta_flutter/presentation/widgets/wallet/wallet_plans_coming_soon.dart';
import 'package:zvolta_flutter/presentation/widgets/wallet/wallet_promo_section.dart';
import 'package:zvolta_flutter/presentation/widgets/wallet/wallet_top_up_bottom_sheet.dart';
import 'package:zvolta_flutter/presentation/widgets/wallet/wallet_weekend_banner.dart';

/// Wallet tab — balance, promo offers, history, and plans.
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>()..add(const WalletRequested()),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  BookingEntity _receiptFromTransaction(WalletTransactionEntity transaction) {
    return BookingEntity(
      id: transaction.id,
      stationName: transaction.stationName ?? transaction.title,
      stationSubtitle: transaction.driverLabel ?? '',
      tab: BookingTab.history,
      status: BookingStatus.completed,
      dateTime: transaction.dateTime,
      totalCostPkr: transaction.amountPkr,
      energyKwh: 0.46,
      chargeSessionId: transaction.chargeSessionId,
    );
  }

  Future<void> _openTopUpSheet(BuildContext context) async {
    final amount = await WalletTopUpBottomSheet.show(context);
    if (amount != null && context.mounted) {
      _showSnackBar(context, 'Top up PKR $amount initiated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            return switch (state) {
              WalletInitial() || WalletLoading() =>
                const AppLoadingIndicator(message: 'Loading wallet...'),
              WalletFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context
                      .read<WalletBloc>()
                      .add(const WalletRefreshRequested()),
                ),
              WalletLoaded walletState => RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<WalletBloc>()
                        .add(const WalletRefreshRequested());
                    await context.read<WalletBloc>().stream.firstWhere(
                          (s) => s is WalletLoaded || s is WalletFailure,
                        );
                  },
                  child: _WalletContent(
                    state: walletState,
                    onTopUpTap: () {
                      _openTopUpSheet(context);
                    },
                    onPromoApply: (code) {
                      context.read<WalletBloc>().add(WalletPromoApplied(code));
                      _showSnackBar(
                        context,
                        code.isEmpty
                            ? 'Enter a promo code'
                            : 'Promo code applied',
                      );
                    },
                    onLearnMoreTap: () =>
                        _showSnackBar(context, 'Weekend offer details'),
                    onReceiptTap: (transaction) {
                      ChargingReceiptBottomSheet.show(
                        context,
                        _receiptFromTransaction(transaction),
                      );
                    },
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _WalletContent extends StatelessWidget {
  const _WalletContent({
    required this.state,
    required this.onTopUpTap,
    required this.onPromoApply,
    required this.onLearnMoreTap,
    required this.onReceiptTap,
  });

  final WalletLoaded state;
  final VoidCallback onTopUpTap;
  final ValueChanged<String> onPromoApply;
  final VoidCallback onLearnMoreTap;
  final ValueChanged<WalletTransactionEntity> onReceiptTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WalletBloc>();

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: WalletHeader(
            summary: state.dashboard.summary,
            selectedTab: state.selectedTab,
            onTabChanged: (tab) => bloc.add(WalletTabChanged(tab)),
            onRefreshTap: () => bloc.add(const WalletRefreshRequested()),
            onTopUpTap: onTopUpTap,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              _buildTabContent(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTabContent() {
    return switch (state.selectedTab) {
      WalletSectionTab.wallet => [
          WalletPromoSection(onApply: onPromoApply),
          const SizedBox(height: 16),
          WalletWeekendBanner(onLearnMoreTap: onLearnMoreTap),
        ],
      WalletSectionTab.history => [
          ...state.dashboard.transactions.map(
            (transaction) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WalletHistoryTransactionCard(
                transaction: transaction,
                onReceiptTap: () => onReceiptTap(transaction),
              ),
            ),
          ),
        ],
      WalletSectionTab.plans => const [
          WalletPlansComingSoon(),
        ],
    };
  }
}
