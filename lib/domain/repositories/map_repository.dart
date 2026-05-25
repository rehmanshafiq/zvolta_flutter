import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';

abstract class MapRepository {
  Future<Result<List<ChargingStationEntity>>> getNearbyStations({
    required double latitude,
    required double longitude,
  });
}
