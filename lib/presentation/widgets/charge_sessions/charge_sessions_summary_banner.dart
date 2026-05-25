import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';

/// Summary stats banner for the charge sessions screen.
class ChargeSessionsSummaryBanner extends StatelessWidget {
  const ChargeSessionsSummaryBanner({
    super.key,
    required this.totalSessions,
    required this.totalKwh,
    required this.totalSpentPkr,
  });

  final int totalSessions;
  final double totalKwh;
  final double totalSpentPkr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.homePrimaryGreen,
            AppColors.homeIconGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.homePrimaryGreen.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _SummaryItem(
            label: 'Sessions',
            value: '$totalSessions',
          ),
          _divider(),
          _SummaryItem(
            label: 'Total kWh',
            value: totalKwh.toStringAsFixed(2),
          ),
          _divider(),
          _SummaryItem(
            label: 'Total Spent',
            value: 'PKR ${totalSpentPkr.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.whiteColor.withValues(alpha: 0.25),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.whiteColor.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
