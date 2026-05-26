class ProfileVehicle {
  const ProfileVehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    this.chassisNumber,
    this.motorNumber,
    this.insurance,
    this.imei,
    this.totalDistanceKm,
    this.batterySerialNumber,
    this.isPrimary = false,
    this.capacityKwh = 8.9,
    this.efficiencyKmPerKwh = 5,
    this.charges = 0,
    this.totalEnergyChargedKwh = 0,
  });

  final String id;
  final String make;
  final String model;
  final String year;
  final String registrationNumber;
  final String? chassisNumber;
  final String? motorNumber;
  final String? insurance;
  final String? imei;
  final String? totalDistanceKm;
  final String? batterySerialNumber;
  final bool isPrimary;
  final double capacityKwh;
  final double efficiencyKmPerKwh;
  final int charges;
  final double totalEnergyChargedKwh;

  ProfileVehicle copyWith({
    String? id,
    String? make,
    String? model,
    String? year,
    String? registrationNumber,
    String? chassisNumber,
    String? motorNumber,
    String? insurance,
    String? imei,
    String? totalDistanceKm,
    String? batterySerialNumber,
    bool? isPrimary,
    double? capacityKwh,
    double? efficiencyKmPerKwh,
    int? charges,
    double? totalEnergyChargedKwh,
  }) {
    return ProfileVehicle(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      motorNumber: motorNumber ?? this.motorNumber,
      insurance: insurance ?? this.insurance,
      imei: imei ?? this.imei,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      batterySerialNumber:
          batterySerialNumber ?? this.batterySerialNumber,
      isPrimary: isPrimary ?? this.isPrimary,
      capacityKwh: capacityKwh ?? this.capacityKwh,
      efficiencyKmPerKwh: efficiencyKmPerKwh ?? this.efficiencyKmPerKwh,
      charges: charges ?? this.charges,
      totalEnergyChargedKwh:
          totalEnergyChargedKwh ?? this.totalEnergyChargedKwh,
    );
  }
}

class ProfileVehicleFormData {
  const ProfileVehicleFormData({
    this.make,
    this.model,
    this.year = '',
    this.registrationNumber = '',
    this.chassisNumber = '',
    this.motorNumber = '',
    this.insurance = '',
    this.imei = '',
    this.totalDistanceKm = '',
    this.batterySerialNumber = '',
  });

  final String? make;
  final String? model;
  final String year;
  final String registrationNumber;
  final String chassisNumber;
  final String motorNumber;
  final String insurance;
  final String imei;
  final String totalDistanceKm;
  final String batterySerialNumber;

  factory ProfileVehicleFormData.fromVehicle(ProfileVehicle vehicle) {
    return ProfileVehicleFormData(
      make: vehicle.make,
      model: vehicle.model,
      year: vehicle.year,
      registrationNumber: vehicle.registrationNumber,
      chassisNumber: vehicle.chassisNumber ?? '',
      motorNumber: vehicle.motorNumber ?? '',
      insurance: vehicle.insurance ?? '',
      imei: vehicle.imei ?? '',
      totalDistanceKm: vehicle.totalDistanceKm ?? '',
      batterySerialNumber: vehicle.batterySerialNumber ?? '',
    );
  }

  ProfileVehicle toVehicle({
    required String id,
    bool isPrimary = false,
    double capacityKwh = 8.9,
    double efficiencyKmPerKwh = 5,
    int charges = 0,
    double totalEnergyChargedKwh = 0,
  }) {
    return ProfileVehicle(
      id: id,
      make: make ?? '',
      model: model ?? '',
      year: year,
      registrationNumber: registrationNumber,
      chassisNumber: _nullable(chassisNumber),
      motorNumber: _nullable(motorNumber),
      insurance: _nullable(insurance),
      imei: _nullable(imei),
      totalDistanceKm: _nullable(totalDistanceKm),
      batterySerialNumber: _nullable(batterySerialNumber),
      isPrimary: isPrimary,
      capacityKwh: capacityKwh,
      efficiencyKmPerKwh: efficiencyKmPerKwh,
      charges: charges,
      totalEnergyChargedKwh: totalEnergyChargedKwh,
    );
  }

  String? _nullable(String value) => value.trim().isEmpty ? null : value.trim();

  bool get isValid =>
      (make?.isNotEmpty ?? false) &&
      (model?.isNotEmpty ?? false) &&
      registrationNumber.trim().isNotEmpty;
}
