import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_vehicle.dart';

class AddVehicleDialog extends StatefulWidget {
  const AddVehicleDialog({
    super.key,
    this.initialData,
    this.title = 'Add New Vehicle',
    this.submitLabel = 'Add Vehicle',
  });

  final ProfileVehicleFormData? initialData;
  final String title;
  final String submitLabel;

  static Future<ProfileVehicleFormData?> show(
    BuildContext context, {
    ProfileVehicleFormData? initialData,
    String title = 'Add New Vehicle',
    String submitLabel = 'Add Vehicle',
  }) {
    return showDialog<ProfileVehicleFormData>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddVehicleDialog(
        initialData: initialData,
        title: title,
        submitLabel: submitLabel,
      ),
    );
  }

  static const _vehicleMakes = [
    'Nissan',
    'Tesla',
    'BYD',
    'MG',
    'Hyundai',
  ];

  static const _modelsByMake = {
    'Nissan': ['Leaf', 'Ariya'],
    'Tesla': ['Model 3', 'Model Y'],
    'BYD': ['Atto 3', 'Dolphin'],
    'MG': ['ZS EV', '4 EV'],
    'Hyundai': ['Ioniq 5', 'Kona Electric'],
  };

  @override
  State<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  late String? _selectedMake = widget.initialData?.make;
  late String? _selectedModel = widget.initialData?.model;

  late final TextEditingController _yearController =
      TextEditingController(text: widget.initialData?.year ?? '');
  late final TextEditingController _registrationController =
      TextEditingController(text: widget.initialData?.registrationNumber ?? '');
  late final TextEditingController _chassisController =
      TextEditingController(text: widget.initialData?.chassisNumber ?? '');
  late final TextEditingController _motorController =
      TextEditingController(text: widget.initialData?.motorNumber ?? '');
  late final TextEditingController _insuranceController =
      TextEditingController(text: widget.initialData?.insurance ?? '');
  late final TextEditingController _imeiController =
      TextEditingController(text: widget.initialData?.imei ?? '');
  late final TextEditingController _distanceController =
      TextEditingController(text: widget.initialData?.totalDistanceKm ?? '');
  late final TextEditingController _batteryController =
      TextEditingController(text: widget.initialData?.batterySerialNumber ?? '');

  @override
  void dispose() {
    _yearController.dispose();
    _registrationController.dispose();
    _chassisController.dispose();
    _motorController.dispose();
    _insuranceController.dispose();
    _imeiController.dispose();
    _distanceController.dispose();
    _batteryController.dispose();
    super.dispose();
  }

  List<String> get _availableModels {
    if (_selectedMake == null) return const [];
    return AddVehicleDialog._modelsByMake[_selectedMake] ?? const [];
  }

  ProfileVehicleFormData get _formData => ProfileVehicleFormData(
        make: _selectedMake,
        model: _selectedModel,
        year: _yearController.text.trim(),
        registrationNumber: _registrationController.text.trim(),
        chassisNumber: _chassisController.text.trim(),
        motorNumber: _motorController.text.trim(),
        insurance: _insuranceController.text.trim(),
        imei: _imeiController.text.trim(),
        totalDistanceKm: _distanceController.text.trim(),
        batterySerialNumber: _batteryController.text.trim(),
      );

  void _submit() {
    if (!_formData.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
        ),
      );
      return;
    }

    Navigator.of(context).pop(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.homeSubtitleGrey,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    _FormRow(
                      children: [
                        _DropdownField(
                          key: ValueKey('make-$_selectedMake'),
                          label: 'Vehicle Make',
                          isRequired: true,
                          value: _selectedMake,
                          hint: 'Select Make',
                          items: AddVehicleDialog._vehicleMakes,
                          onChanged: (value) {
                            setState(() {
                              _selectedMake = value;
                              _selectedModel = null;
                            });
                          },
                        ),
                        _DropdownField(
                          key: ValueKey('model-$_selectedMake-$_selectedModel'),
                          label: 'Vehicle Model',
                          isRequired: true,
                          value: _selectedModel,
                          hint: 'Select Model',
                          items: _availableModels,
                          onChanged: _selectedMake == null
                              ? null
                              : (value) {
                                  setState(() => _selectedModel = value);
                                },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormRow(
                      children: [
                        _TextField(
                          label: 'Year',
                          controller: _yearController,
                          hint: 'e.g., 2022',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                        ),
                        _TextField(
                          label: 'Registration Number',
                          isRequired: true,
                          controller: _registrationController,
                          hint: 'e.g., ISB-2022-041',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormRow(
                      children: [
                        _TextField(
                          label: 'Chassis Number',
                          controller: _chassisController,
                          hint: 'e.g., 1N4AZ0CP5',
                        ),
                        _TextField(
                          label: 'Motor Number',
                          controller: _motorController,
                          hint: 'e.g., MTR-LEAF-0',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormRow(
                      children: [
                        _TextField(
                          label: 'Insurance',
                          controller: _insuranceController,
                          hint: 'e.g., INS-NISSAN-',
                        ),
                        _TextField(
                          label: 'IMEI (15 digits)',
                          controller: _imeiController,
                          hint: 'e.g., 987654321012345',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormRow(
                      children: [
                        _TextField(
                          label: 'Total Distance (km)',
                          controller: _distanceController,
                          hint: 'e.g., 8750.3',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _TextField(
                          label: 'Battery Serial Number',
                          controller: _batteryController,
                          hint: 'e.g., BAT-NISSAN-',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 32, color: AppColors.myAccountBorderColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.blackColor,
                      side: const BorderSide(color: AppColors.dividerColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.homePrimaryGreen,
                      foregroundColor: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.submitLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.removeColor),
              ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    required this.hint,
    this.isRequired = false,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, isRequired: isRequired),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.blackColor,
          ),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
  });

  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, isRequired: isRequired),
        DropdownMenu<String>(
          initialSelection: value,
          enabled: onChanged != null,
          hintText: hint,
          onSelected: onChanged,
          dropdownMenuEntries: items
              .map(
                (item) => DropdownMenuEntry<String>(
                  value: item,
                  label: item,
                ),
              )
              .toList(),
          textStyle: const TextStyle(
            fontSize: 13,
            color: AppColors.blackColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.whiteColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.mapPinBlueColor,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 13,
      color: AppColors.homeSubtitleGrey,
    ),
    filled: true,
    fillColor: AppColors.whiteColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.mapPinBlueColor,
        width: 1.2,
      ),
    ),
  );
}
