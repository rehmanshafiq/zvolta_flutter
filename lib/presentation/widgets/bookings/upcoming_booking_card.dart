import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

class UpcomingBookingCard extends StatelessWidget {
  const UpcomingBookingCard({
    super.key,
    required this.booking,
    required this.onScanTap,
    required this.onModifyTap,
    required this.onCancelTap,
  });

  final BookingEntity booking;
  final VoidCallback onScanTap;
  final VoidCallback onModifyTap;
  final VoidCallback onCancelTap;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.bottomNavActivePillColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.event_rounded,
                    color: AppColors.homeIconGreen,
                    size: 24,
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
                        booking.stationSubtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.homeSubtitleGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(
                  label: booking.statusLabel,
                  filled: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.homeSubtitleGrey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateFormat.format(booking.dateTime),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.homeSubtitleGrey,
                    ),
                  ),
                ),
                if (booking.durationMinutes != null) ...[
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: AppColors.homeSubtitleGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${booking.durationMinutes} mins',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.homeSubtitleGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.bottomNavActivePillColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Text(
                    'Estimated Cost',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${booking.estimatedCostPkr?.round() ?? 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: OutlinedButton.icon(
              onPressed: onScanTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.blackColor,
                side: const BorderSide(color: AppColors.homeCardBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
              label: const Text(
                'Scan Charging Pod QR',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onModifyTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.blackColor,
                      side: const BorderSide(color: AppColors.homeCardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Modify',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancelTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.removeColor,
                      side: const BorderSide(color: AppColors.removeColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.filled,
  });

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? AppColors.homePrimaryGreen : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: filled ? AppColors.homePrimaryGreen : AppColors.homeIconGreen,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: filled ? AppColors.whiteColor : AppColors.homeIconGreen,
        ),
      ),
    );
  }
}
