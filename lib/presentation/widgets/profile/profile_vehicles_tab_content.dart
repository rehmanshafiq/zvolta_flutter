import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_dashboard_card.dart';

class ProfileVehiclesTabContent extends StatelessWidget {
  const ProfileVehiclesTabContent({super.key});

  static const _patterns = [
    ('Most Active Day', 'Wed'),
    ('Preferred Time', '12:00:00'),
    ('Avg. Charge Duration', '1113.87 Min'),
    ('Favorite Station', 'Workhall PECHS <> Zvolta'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.splashBackground,
              foregroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'Add New Vehicle',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: AppColors.homeBadgeBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'No vehicles found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.homeSubtitleGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        HomeDashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.homeIconGreen,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Charging Patterns',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppColors.homeSubtitleGrey,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < _patterns.length; i++) ...[
                _PatternRow(
                  label: _patterns[i].$1,
                  value: _patterns[i].$2,
                ),
                if (i < _patterns.length - 1)
                  const Divider(
                    height: 1,
                    color: AppColors.myAccountBorderColor,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({
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
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.homeSubtitleGrey,
              ),
            ),
          ),
          Flexible(
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
