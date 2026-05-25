import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';

class NearbyStationCard extends StatelessWidget {
  const NearbyStationCard({
    super.key,
    required this.station,
    required this.onFavoriteTap,
    required this.onBookTap,
    this.compact = false,
  });

  final ChargingStationEntity station;
  final VoidCallback onFavoriteTap;
  final VoidCallback onBookTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: compact ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.homeCardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _StationThumbnail(station: station),
                  const SizedBox(height: 8),
                  Text(
                    'Sockets: ${station.socketCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6, right: 6),
                          decoration: BoxDecoration(
                            color: station.isOnline
                                ? AppColors.homeIconGreen
                                : AppColors.homeSubtitleGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            station.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onFavoriteTap,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            station.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: station.isFavorite
                                ? AppColors.redColor
                                : AppColors.homeSubtitleGrey,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      station.address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.homeSubtitleGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (station.isOnline)
                          _StatusChip(
                            label: 'Online',
                            backgroundColor: AppColors.homeAccentGreen,
                            foregroundColor: AppColors.whiteColor,
                          ),
                        _StatusChip(
                          label: station.availabilityLabel,
                          backgroundColor: station.availability ==
                                  StationAvailability.available
                              ? AppColors.homeAccentGreen
                              : AppColors.homeRangeImpactOrange,
                          foregroundColor: AppColors.whiteColor,
                        ),
                        _StatusChip(
                          label: station.connectorLabel,
                          backgroundColor: AppColors.homeBadgeBackground,
                          foregroundColor: AppColors.blackColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 4, top: 28),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.homeBadgeBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${station.distanceKm} km',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.homeSubtitleGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bottomNavActivePillColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  '${station.powerKw} KW - ${station.brandName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.homeSubtitleGrey,
                    ),
                    children: [
                      const TextSpan(text: 'Sell Price: '),
                      TextSpan(
                        text: 'PKR ${station.sellPricePkr}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: FilledButton(
              onPressed: onBookTap,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.homePrimaryGreen,
                foregroundColor: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StationThumbnail extends StatelessWidget {
  const _StationThumbnail({required this.station});

  final ChargingStationEntity station;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            AppColors.bottomNavActivePillColor,
            AppColors.homeCardBorder,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.ev_station_rounded,
        color: AppColors.homePrimaryGreen,
        size: 36,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
    );
  }
}
