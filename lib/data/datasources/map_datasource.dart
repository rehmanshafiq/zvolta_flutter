import 'dart:math';

import 'package:zvolta_flutter/data/models/charging_station_model.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';

class MapLocalDataSource {
  static const defaultLatitude = 24.8607;
  static const defaultLongitude = 67.0798;

  Future<List<ChargingStationModel>> getNearbyStations({
    required double latitude,
    required double longitude,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    const stations = [
      ChargingStationModel(
        id: '1',
        name: 'ZVolta Head Office - 7KW',
        address: 'Block 6, P.E.C.H.S',
        latitude: 24.8612,
        longitude: 67.0792,
        powerKw: 7,
        connectorType: StationConnectorType.ac,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 1,
        sellPricePkr: 90,
      ),
      ChargingStationModel(
        id: '2',
        name: 'Vlektra Station 1 - 22KW',
        address: 'Shaheed-e-Millat Road',
        latitude: 24.8675,
        longitude: 67.0745,
        powerKw: 22,
        connectorType: StationConnectorType.dc,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 2,
        sellPricePkr: 120,
      ),
      ChargingStationModel(
        id: '3',
        name: 'ZVolta Clifton - 11KW',
        address: 'Block 5, Clifton',
        latitude: 24.8138,
        longitude: 67.0299,
        powerKw: 11,
        connectorType: StationConnectorType.ac,
        isOnline: true,
        availability: StationAvailability.busy,
        socketCount: 1,
        sellPricePkr: 95,
      ),
      ChargingStationModel(
        id: '4',
        name: 'ZVolta DHA Phase 6',
        address: 'Khayaban-e-Shaheen',
        latitude: 24.7924,
        longitude: 67.0562,
        powerKw: 7,
        connectorType: StationConnectorType.ac,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 2,
        sellPricePkr: 85,
      ),
      ChargingStationModel(
        id: '5',
        name: 'Vlektra Gulshan',
        address: 'Block 13-D, Gulshan',
        latitude: 24.9201,
        longitude: 67.0821,
        powerKw: 22,
        connectorType: StationConnectorType.dc,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 3,
        sellPricePkr: 110,
      ),
      ChargingStationModel(
        id: '6',
        name: 'ZVolta North Nazimabad',
        address: 'Block H, North Nazimabad',
        latitude: 24.9367,
        longitude: 67.0354,
        powerKw: 7,
        connectorType: StationConnectorType.ac,
        isOnline: false,
        availability: StationAvailability.offline,
        socketCount: 1,
        sellPricePkr: 80,
      ),
      ChargingStationModel(
        id: '7',
        name: 'ZVolta Saddar Hub',
        address: 'Preedy Street, Saddar',
        latitude: 24.8549,
        longitude: 67.0185,
        powerKw: 11,
        connectorType: StationConnectorType.ac,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 2,
        sellPricePkr: 100,
      ),
      ChargingStationModel(
        id: '8',
        name: 'Vlektra Korangi',
        address: 'Industrial Area, Korangi',
        latitude: 24.8267,
        longitude: 67.1345,
        powerKw: 22,
        connectorType: StationConnectorType.dc,
        isOnline: true,
        availability: StationAvailability.busy,
        socketCount: 2,
        sellPricePkr: 105,
      ),
      ChargingStationModel(
        id: '9',
        name: 'ZVolta Malir',
        address: 'Malir Cantt',
        latitude: 24.9023,
        longitude: 67.1987,
        powerKw: 7,
        connectorType: StationConnectorType.ac,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 1,
        sellPricePkr: 75,
      ),
      ChargingStationModel(
        id: '10',
        name: 'ZVolta Bahria Town',
        address: 'Precinct 10, Bahria Town',
        latitude: 25.0123,
        longitude: 67.3089,
        powerKw: 11,
        connectorType: StationConnectorType.ac,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 2,
        sellPricePkr: 88,
      ),
      ChargingStationModel(
        id: '11',
        name: 'Vlektra Shahrah-e-Faisal',
        address: 'Near Duty Free Shop',
        latitude: 24.8712,
        longitude: 67.0945,
        powerKw: 22,
        connectorType: StationConnectorType.dc,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 2,
        sellPricePkr: 115,
      ),
      ChargingStationModel(
        id: '12',
        name: 'ZVolta Tariq Road',
        address: 'Near Portia Fabrics',
        latitude: 24.8698,
        longitude: 67.0612,
        powerKw: 7,
        connectorType: StationConnectorType.ac,
        isOnline: true,
        availability: StationAvailability.available,
        socketCount: 1,
        sellPricePkr: 92,
      ),
    ];

    return stations
        .map(
          (station) => station.copyWithDistance(
            _distanceKm(
              latitude,
              longitude,
              station.latitude,
              station.longitude,
            ),
          ),
        )
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  double _distanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return double.parse((earthRadius * c).toStringAsFixed(1));
  }

  double _degToRad(double deg) => deg * pi / 180;
}
