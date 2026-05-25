import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/domain/entities/booking_entity.dart';

class BookingsTabBar extends StatelessWidget {
  const BookingsTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final BookingTab selectedTab;
  final ValueChanged<BookingTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.homeBadgeBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _BookingsTabChip(
            label: 'Active',
            isSelected: selectedTab == BookingTab.active,
            onTap: () => onTabChanged(BookingTab.active),
          ),
          _BookingsTabChip(
            label: 'Upcoming',
            isSelected: selectedTab == BookingTab.upcoming,
            onTap: () => onTabChanged(BookingTab.upcoming),
          ),
          _BookingsTabChip(
            label: 'History',
            isSelected: selectedTab == BookingTab.history,
            onTap: () => onTabChanged(BookingTab.history),
          ),
        ],
      ),
    );
  }
}

class _BookingsTabChip extends StatelessWidget {
  const _BookingsTabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected ? AppColors.whiteColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        elevation: isSelected ? 1 : 0,
        shadowColor: AppColors.blackColor.withValues(alpha: 0.08),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.blackColor
                    : AppColors.homeSubtitleGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
