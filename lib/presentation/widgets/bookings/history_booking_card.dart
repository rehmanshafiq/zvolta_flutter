import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

class HistoryBookingCard extends StatelessWidget {
  const HistoryBookingCard({
    super.key,
    required this.booking,
    required this.onReceiptTap,
  });

  final BookingEntity booking;
  final VoidCallback onReceiptTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('M/d/yyyy, h:mm:ss a');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.homeCardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.homePrimaryGreen.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
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
                        booking.stationName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(booking.dateTime),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.homeSubtitleGrey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.homeSubtitleGrey,
                          ),
                          children: [
                            TextSpan(text: booking.timeAgo ?? ''),
                            if (booking.energyKwh != null) ...[
                              const TextSpan(text: ' · '),
                              TextSpan(
                                text: '${booking.energyKwh!.toStringAsFixed(2)} kWh',
                                style: const TextStyle(
                                  color: AppColors.homeAccentGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.homePrimaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.statusLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'PKR ${booking.totalCostPkr?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.homeCardBorder.withValues(alpha: 0.8),
          ),
          InkWell(
            onTap: onReceiptTap,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'View Receipt',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
