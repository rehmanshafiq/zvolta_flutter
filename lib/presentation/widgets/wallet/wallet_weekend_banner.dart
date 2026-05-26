import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';

class WalletWeekendBanner extends StatelessWidget {
  const WalletWeekendBanner({super.key, required this.onLearnMoreTap});

  final VoidCallback onLearnMoreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.homePrimaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor.withValues(alpha: 0.06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.homeAccentGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Limited Time',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Weekend Special',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Get 20% cashback on all charges this weekend',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.whiteColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: onLearnMoreTap,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.whiteColor,
                  foregroundColor: AppColors.homeRangeImpactOrange,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Learn More',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
