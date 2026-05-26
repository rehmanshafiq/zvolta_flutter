import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';

enum ProfileSectionTab { profile, vehicles, settings }

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.username,
    required this.email,
    required this.memberSince,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final String username;
  final String email;
  final String memberSince;
  final ProfileSectionTab selectedTab;
  final ValueChanged<ProfileSectionTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.whiteColor.withValues(alpha: 0.15),
                        border: Border.all(
                          color: AppColors.whiteColor.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppColors.mapPinBlueColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.homePrimaryGreen,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 13,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              email,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.whiteColor.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: AppColors.mapPinBlueColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        memberSince,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.whiteColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _ProfileTabChip(
                  label: 'Profile',
                  icon: Icons.person_outline_rounded,
                  isSelected: selectedTab == ProfileSectionTab.profile,
                  onTap: () => onTabChanged(ProfileSectionTab.profile),
                ),
                const SizedBox(width: 8),
                _ProfileTabChip(
                  label: 'Vehicles',
                  icon: Icons.directions_car_outlined,
                  isSelected: selectedTab == ProfileSectionTab.vehicles,
                  onTap: () => onTabChanged(ProfileSectionTab.vehicles),
                ),
                const SizedBox(width: 8),
                _ProfileTabChip(
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                  isSelected: selectedTab == ProfileSectionTab.settings,
                  onTap: () => onTabChanged(ProfileSectionTab.settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTabChip extends StatelessWidget {
  const _ProfileTabChip({
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
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.whiteColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
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
    );
  }
}
