import 'package:equatable/equatable.dart';

enum StationConnectorType { ac, dc }

enum StationAvailability { available, busy, offline }

/// Pure domain entity for a charging station on the map.
class ChargingStationEntity extends Equatable {
  const ChargingStationEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.powerKw,
    required this.connectorType,
    required this.isOnline,
    required this.availability,
    required this.socketCount,
    required this.sellPricePkr,
    required this.distanceKm,
    required this.isFavorite,
    this.brandName = 'ZVolta',
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int powerKw;
  final StationConnectorType connectorType;
  final bool isOnline;
  final StationAvailability availability;
  final int socketCount;
  final int sellPricePkr;
  final double distanceKm;
  final bool isFavorite;
  final String brandName;

  String get connectorLabel =>
      connectorType == StationConnectorType.ac ? 'AC' : 'DC';

  String get availabilityLabel => switch (availability) {
        StationAvailability.available => 'Available',
        StationAvailability.busy => 'Busy',
        StationAvailability.offline => 'Offline',
      };

  ChargingStationEntity copyWith({
    bool? isFavorite,
    double? distanceKm,
  }) {
    return ChargingStationEntity(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      powerKw: powerKw,
      connectorType: connectorType,
      isOnline: isOnline,
      availability: availability,
      socketCount: socketCount,
      sellPricePkr: sellPricePkr,
      distanceKm: distanceKm ?? this.distanceKm,
      isFavorite: isFavorite ?? this.isFavorite,
      brandName: brandName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        powerKw,
        connectorType,
        isOnline,
        availability,
        socketCount,
        sellPricePkr,
        distanceKm,
        isFavorite,
        brandName,
      ];
}
