import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';

class ChargingStationModel {
  const ChargingStationModel({
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
    this.distanceKm = 0,
    this.isFavorite = false,
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

  ChargingStationModel copyWithDistance(double distanceKm) {
    return ChargingStationModel(
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
      distanceKm: distanceKm,
      isFavorite: isFavorite,
      brandName: brandName,
    );
  }

  ChargingStationEntity toEntity() {
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
      distanceKm: distanceKm,
      isFavorite: isFavorite,
      brandName: brandName,
    );
  }
}
