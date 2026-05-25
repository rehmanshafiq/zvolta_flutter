import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_event.dart';

class MapViewToggle extends StatelessWidget {
  const MapViewToggle({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    required this.onNearMeTap,
  });

  final MapViewMode selectedMode;
  final ValueChanged<MapViewMode> onModeChanged;
  final VoidCallback onNearMeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.homeCardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToggleChip(
                label: 'Map',
                icon: Icons.map_outlined,
                isSelected: selectedMode == MapViewMode.map,
                onTap: () => onModeChanged(MapViewMode.map),
              ),
              _ToggleChip(
                label: 'List',
                icon: Icons.view_list_rounded,
                isSelected: selectedMode == MapViewMode.list,
                onTap: () => onModeChanged(MapViewMode.list),
              ),
            ],
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: onNearMeTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.homePrimaryGreen,
            side: const BorderSide(color: AppColors.homePrimaryGreen),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          icon: const Icon(Icons.near_me_outlined, size: 18),
          label: const Text(
            'Near Me',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.homePrimaryGreen : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.whiteColor
                    : AppColors.homeSubtitleGrey,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.homeSubtitleGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
