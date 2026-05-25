import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_dashboard_card.dart';

/// Weather and range impact card.
class HomeWeatherRangeCard extends StatelessWidget {
  const HomeWeatherRangeCard({
    super.key,
    required this.weatherCondition,
    required this.temperatureCelsius,
    required this.city,
    required this.rangeImpactKm,
  });

  final String weatherCondition;
  final int temperatureCelsius;
  final String city;
  final int rangeImpactKm;

  @override
  Widget build(BuildContext context) {
    return HomeDashboardCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.homePrimaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wb_sunny_outlined,
              color: AppColors.whiteColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$weatherCondition, $temperatureCelsius°C',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  city,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.homeSubtitleGrey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Range Impact',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.homeSubtitleGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$rangeImpactKm km',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.homeRangeImpactOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
