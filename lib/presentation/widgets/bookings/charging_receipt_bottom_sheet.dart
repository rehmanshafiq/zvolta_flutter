import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

class ChargingReceiptBottomSheet extends StatelessWidget {
  const ChargingReceiptBottomSheet({
    super.key,
    required this.booking,
  });

  final BookingEntity booking;

  static Future<void> show(BuildContext context, BookingEntity booking) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ChargingReceiptBottomSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    final dateFormat = DateFormat('M/d/yyyy, h:mm:ss a');

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 10, 24, bottomPadding + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.greyBottomSheetThumbColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 18),
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: const [
                    Text(
                      'Charging Receipt',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Details of your charging session',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.homeSubtitleGrey,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.homeSubtitleGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.homeCardBorder),
              ),
              child: Column(
                children: [
                  _ReceiptRow(
                    label: 'Charge Session ID',
                    value: booking.chargeSessionId ?? booking.id,
                  ),
                  const SizedBox(height: 14),
                  _ReceiptRow(
                    label: 'Station',
                    value: booking.stationName,
                  ),
                  const SizedBox(height: 14),
                  _ReceiptRow(
                    label: 'Date',
                    value: dateFormat.format(booking.dateTime),
                  ),
                  const SizedBox(height: 14),
                  _ReceiptRow(
                    label: 'Energy Used',
                    value: '${booking.energyKwh?.toStringAsFixed(2) ?? '0.00'} kWh',
                    valueColor: AppColors.homePrimaryGreen,
                    valueWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.homeSubtitleGrey,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.homePrimaryGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booking.statusLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Divider(
                    height: 1,
                    color: AppColors.homeCardBorder.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const Spacer(),
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading receipt...')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.blackColor,
                  foregroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.download_rounded, size: 22),
                label: const Text(
                  'Download Receipt',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.blackColor,
    this.valueWeight = FontWeight.w600,
  });

  final String label;
  final String value;
  final Color valueColor;
  final FontWeight valueWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.homeSubtitleGrey,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: valueWeight,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
