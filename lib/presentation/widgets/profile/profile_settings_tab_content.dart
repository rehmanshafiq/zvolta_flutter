import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_dashboard_card.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_coming_soon_card.dart';

class ProfileSettingsTabContent extends StatelessWidget {
  const ProfileSettingsTabContent({
    super.key,
    required this.onLogoutTap,
  });

  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileComingSoonCard(
          title: 'Language Selection & App Settings',
        ),
        const SizedBox(height: 16),
        HomeDashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ZVolta EV APP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.homeSubtitleGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Charging Network',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.homeIconGreen.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: onLogoutTap,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.removeColor,
              foregroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.logout_rounded, size: 20),
            label: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
