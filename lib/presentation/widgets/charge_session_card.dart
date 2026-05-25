import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/recent_charge_entity.dart';

/// Shared charge session card used on home and charge sessions screens.
class ChargeSessionCard extends StatelessWidget {
  const ChargeSessionCard({
    super.key,
    required this.charge,
    this.showShadow = false,
  });

  final RecentChargeEntity charge;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.homeCardBorder),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.homePrimaryGreen.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.bottomNavActivePillColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.homeIconGreen,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  charge.stationName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  charge.timeAgo,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.homeSubtitleGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.homeBadgeBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Selling Cost Per Unit: PKR ${charge.costPerUnitPkr}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.homeSubtitleGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'PKR ${charge.totalCostPkr.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '+${charge.energyKwh.toStringAsFixed(2)} kWh',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.homeAccentGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
