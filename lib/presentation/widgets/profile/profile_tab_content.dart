import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_dashboard_card.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_coming_soon_card.dart';

class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: const [
        _ProfileStatCard(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.mapPinBlueColor,
          value: '506',
          label: 'Total Charges',
        ),
        _ProfileStatCard(
          icon: Icons.battery_charging_full_rounded,
          iconColor: AppColors.homeIconGreen,
          value: '527.86',
          label: 'kWh Charged',
        ),
        _ProfileStatCard(
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.homeRangeImpactOrange,
          value: 'PKR 0',
          label: 'Money Saved',
        ),
        _ProfileStatCard(
          icon: Icons.emoji_events_outlined,
          iconColor: AppColors.homeIconGreen,
          value: '285 kg',
          label: 'CO₂ Reduced',
        ),
      ],
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return HomeDashboardCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.homeSubtitleGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAchievementsSection extends StatelessWidget {
  const ProfileAchievementsSection({super.key});

  static const _achievements = [
    _Achievement(
      label: 'Early Adopter',
      icon: Icons.emoji_events_outlined,
      backgroundColor: Color(0xFFFFF3CD),
      iconColor: Color(0xFFE6A800),
    ),
    _Achievement(
      label: 'Eco Warrior',
      icon: Icons.eco_outlined,
      backgroundColor: Color(0xFFE4F4E8),
      iconColor: AppColors.homeIconGreen,
    ),
    _Achievement(
      label: 'Road Tripper',
      icon: Icons.directions_car_outlined,
      backgroundColor: Color(0xFFE3F2FD),
      iconColor: AppColors.mapPinBlueColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return HomeDashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 20,
                color: AppColors.mapPinBlueColor,
              ),
              SizedBox(width: 8),
              Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < _achievements.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(child: _AchievementBadge(achievement: _achievements[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Achievement {
  const _Achievement({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.achievement});

  final _Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: achievement.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            achievement.icon,
            color: achievement.iconColor,
            size: 26,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          achievement.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}

class ProfilePersonalInfoCard extends StatelessWidget {
  const ProfilePersonalInfoCard({super.key});

  static const _fields = [
    ('Full Name', 'Driver 2'),
    ('User Name', 'driver-2'),
    ('Email', 'friver2@gmail.com'),
    ('Phone', '+92 3128754213'),
  ];

  @override
  Widget build(BuildContext context) {
    return HomeDashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mapPinBlueColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: AppColors.mapPinBlueColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mapPinBlueColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _fields.length; i++) ...[
            _InfoRow(label: _fields[i].$1, value: _fields[i].$2),
            if (i < _fields.length - 1)
              const Divider(height: 1, color: AppColors.myAccountBorderColor),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.homeSubtitleGrey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProfileStatsGrid(),
        SizedBox(height: 16),
        ProfileAchievementsSection(),
        SizedBox(height: 16),
        ProfilePersonalInfoCard(),
        SizedBox(height: 16),
        ProfileComingSoonCard(title: 'Driving Efficiency'),
      ],
    );
  }
}
