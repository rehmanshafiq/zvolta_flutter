import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/home/home_dashboard_card.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/add_vehicle_dialog.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_vehicle.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_vehicle_card.dart';

class ProfileVehiclesTabContent extends StatefulWidget {
  const ProfileVehiclesTabContent({super.key});

  @override
  State<ProfileVehiclesTabContent> createState() =>
      _ProfileVehiclesTabContentState();
}

class _ProfileVehiclesTabContentState extends State<ProfileVehiclesTabContent> {
  static const _patterns = [
    ('Most Active Day', 'Wed'),
    ('Preferred Time', '12:00:00'),
    ('Avg. Charge Duration', '1113.87 Min'),
    ('Favorite Station', 'Workhall PECHS <> Zvolta'),
  ];

  final List<ProfileVehicle> _vehicles = [
    const ProfileVehicle(
      id: 'vehicle-1',
      make: 'Nissan',
      model: 'Leaf',
      year: '2022',
      registrationNumber: 'ISB-73473',
      isPrimary: true,
      capacityKwh: 8.9,
      efficiencyKmPerKwh: 5,
      charges: 498,
      totalEnergyChargedKwh: 526.3,
    ),
  ];

  int _nextVehicleId = 2;

  Future<void> _openAddVehicleDialog() async {
    final formData = await AddVehicleDialog.show(context);
    if (formData == null || !mounted) return;

    setState(() {
      _vehicles.add(
        formData.toVehicle(
          id: 'vehicle-${_nextVehicleId++}',
          isPrimary: _vehicles.isEmpty,
        ),
      );
    });
  }

  Future<void> _openEditVehicleDialog(ProfileVehicle vehicle) async {
    final formData = await AddVehicleDialog.show(
      context,
      initialData: ProfileVehicleFormData.fromVehicle(vehicle),
      title: 'Edit Vehicle',
      submitLabel: 'Save Changes',
    );
    if (formData == null || !mounted) return;

    setState(() {
      final index = _vehicles.indexWhere((item) => item.id == vehicle.id);
      if (index == -1) return;

      _vehicles[index] = formData.toVehicle(
        id: vehicle.id,
        isPrimary: vehicle.isPrimary,
        capacityKwh: vehicle.capacityKwh,
        efficiencyKmPerKwh: vehicle.efficiencyKmPerKwh,
        charges: vehicle.charges,
        totalEnergyChargedKwh: vehicle.totalEnergyChargedKwh,
      );
    });
  }

  Future<void> _confirmDeleteVehicle(ProfileVehicle vehicle) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text(
          'Remove ${vehicle.registrationNumber} from your vehicles?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.removeColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    setState(() {
      _vehicles.removeWhere((item) => item.id == vehicle.id);
      if (_vehicles.isNotEmpty && !_vehicles.any((item) => item.isPrimary)) {
        _vehicles[0] = _vehicles.first.copyWith(isPrimary: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canAddVehicle = _vehicles.isEmpty;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: canAddVehicle ? _openAddVehicleDialog : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.splashBackground,
              foregroundColor: AppColors.whiteColor,
              disabledBackgroundColor:
                  AppColors.splashBackground.withValues(alpha: 0.45),
              disabledForegroundColor:
                  AppColors.whiteColor.withValues(alpha: 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'Add New Vehicle',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_vehicles.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.homeBadgeBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'No vehicles found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.homeSubtitleGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          ..._vehicles.map(
            (vehicle) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProfileVehicleCard(
                vehicle: vehicle,
                onEditTap: () => _openEditVehicleDialog(vehicle),
                onDeleteTap: () => _confirmDeleteVehicle(vehicle),
              ),
            ),
          ),
        HomeDashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.homeIconGreen,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Charging Patterns',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppColors.homeSubtitleGrey,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < _patterns.length; i++) ...[
                _PatternRow(
                  label: _patterns[i].$1,
                  value: _patterns[i].$2,
                ),
                if (i < _patterns.length - 1)
                  const Divider(
                    height: 1,
                    color: AppColors.myAccountBorderColor,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.homeSubtitleGrey,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
