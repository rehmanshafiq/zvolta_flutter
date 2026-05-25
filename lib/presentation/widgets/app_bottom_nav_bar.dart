import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_event.dart';

/// Single bottom navigation destination.
class BottomNavItem {
  const BottomNavItem({
    required this.tab,
    required this.label,
    required this.icon,
  });

  final BottomNavTab tab;
  final String label;
  final IconData icon;
}

/// Custom bottom navigation bar matching the app design.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  static const items = <BottomNavItem>[
    BottomNavItem(
      tab: BottomNavTab.home,
      label: 'Home',
      icon: Icons.home_outlined,
    ),
    BottomNavItem(
      tab: BottomNavTab.map,
      label: 'Map',
      icon: Icons.map_outlined,
    ),
    BottomNavItem(
      tab: BottomNavTab.bookings,
      label: 'Bookings',
      icon: Icons.calendar_today_outlined,
    ),
    BottomNavItem(
      tab: BottomNavTab.wallet,
      label: 'Wallet',
      icon: Icons.account_balance_wallet_outlined,
    ),
    BottomNavItem(
      tab: BottomNavTab.profile,
      label: 'Profile',
      icon: Icons.person_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(
          top: BorderSide(color: AppColors.colorsOutlineColor),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: _BottomNavTile(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onItemSelected(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavTile extends StatelessWidget {
  const _BottomNavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final contentColor = isSelected
        ? AppColors.bottomNavActiveColor
        : AppColors.bottomNavInactiveColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.bottomNavActivePillColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: contentColor,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
