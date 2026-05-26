import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/wallet_entity.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    super.key,
    required this.summary,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onRefreshTap,
    required this.onTopUpTap,
  });

  final WalletSummaryEntity summary;
  final WalletSectionTab selectedTab;
  final ValueChanged<WalletSectionTab> onTabChanged;
  final VoidCallback onRefreshTap;
  final VoidCallback onTopUpTap;

  @override
  Widget build(BuildContext context) {
    final balanceFormat = NumberFormat('#,##0');

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.homePrimaryGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wallet',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.splashBackground.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'PKR ${balanceFormat.format(summary.availableBalancePkr)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onRefreshTap,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _BalanceStat(
                          label: 'This Month',
                          value:
                              'PKR ${balanceFormat.format(summary.thisMonthPkr)}',
                          valueColor: AppColors.whiteColor,
                        ),
                      ),
                      Expanded(
                        child: _BalanceStat(
                          label: 'Hold Balance',
                          value:
                              'PKR ${balanceFormat.format(summary.holdBalancePkr)}',
                          valueColor: AppColors.homeAccentGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: onTopUpTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.whiteColor,
                        foregroundColor: AppColors.homeAccentGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add_rounded, size: 22),
                      label: const Text(
                        'Top Up Wallet',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _WalletTabChip(
                  label: 'Wallet',
                  icon: Icons.account_balance_wallet_outlined,
                  isSelected: selectedTab == WalletSectionTab.wallet,
                  onTap: () => onTabChanged(WalletSectionTab.wallet),
                ),
                const SizedBox(width: 8),
                _WalletTabChip(
                  label: 'History',
                  icon: Icons.show_chart_rounded,
                  isSelected: selectedTab == WalletSectionTab.history,
                  onTap: () => onTabChanged(WalletSectionTab.history),
                ),
                const SizedBox(width: 8),
                _WalletTabChip(
                  label: 'Plans',
                  icon: Icons.workspace_premium_outlined,
                  isSelected: selectedTab == WalletSectionTab.plans,
                  onTap: () => onTabChanged(WalletSectionTab.plans),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  const _BalanceStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.whiteColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _WalletTabChip extends StatelessWidget {
  const _WalletTabChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? AppColors.homeAccentGreen : AppColors.whiteColor;

    return Expanded(
      child: Material(
        color: isSelected ? AppColors.whiteColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
