import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';

/// Reusable bordered card used across the home dashboard.
class HomeDashboardCard extends StatelessWidget {
  const HomeDashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = AppColors.whiteColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.homeCardBorder),
      ),
      child: child,
    );
  }
}
