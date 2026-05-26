import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_dashboard_card.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_vehicle.dart';

class ProfileVehicleCard extends StatelessWidget {
  const ProfileVehicleCard({
    super.key,
    required this.vehicle,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final ProfileVehicle vehicle;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return HomeDashboardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  color: AppColors.shimmerGreyColor,
                  child: Icon(
                    Icons.directions_car_outlined,
                    size: 72,
                    color: AppColors.homeIconGreen.withValues(alpha: 0.45),
                  ),
                ),
              ),
              if (vehicle.isPrimary)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.homePrimaryGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Primary Vehicle',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reg No: ${vehicle.registrationNumber}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vehicle.year,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.homeSubtitleGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onEditTap,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onDeleteTap,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: AppColors.removeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _VehicleStatBox(
                        icon: Icons.battery_charging_full_rounded,
                        iconColor: AppColors.homeIconGreen,
                        label: 'Capacity',
                        value: '${vehicle.capacityKwh} kWh',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _VehicleStatBox(
                        icon: Icons.trending_up_rounded,
                        iconColor: AppColors.homeIconGreen,
                        label: 'Efficiency',
                        value: '${vehicle.efficiencyKmPerKwh.toInt()} KM/Kwh',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _VehicleStatBox(
                        icon: Icons.bolt_rounded,
                        iconColor: AppColors.homeRangeImpactOrange,
                        label: 'Charges',
                        value: vehicle.charges.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.myAccountBorderColor),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Energy Charged',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.homeSubtitleGrey,
                        ),
                      ),
                    ),
                    Text(
                      '${vehicle.totalEnergyChargedKwh} kWh',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleStatBox extends StatelessWidget {
  const _VehicleStatBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.homeBadgeBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.homeSubtitleGrey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
