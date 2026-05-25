import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';

class BookingsScanButton extends StatelessWidget {
  const BookingsScanButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.splashBackground,
          foregroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.qr_code_scanner_rounded, size: 22),
        label: const Text(
          'Scan me',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
