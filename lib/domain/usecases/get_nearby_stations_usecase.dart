import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/core/utils/usecase.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';
import 'package:zvolta_flutter/domain/repositories/map_repository.dart';

class GetNearbyStationsParams {
  const GetNearbyStationsParams({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class GetNearbyStationsUseCase
    implements UseCase<List<ChargingStationEntity>, GetNearbyStationsParams> {
  GetNearbyStationsUseCase(this._repository);

  final MapRepository _repository;

  @override
  Future<Result<List<ChargingStationEntity>>> call(
    GetNearbyStationsParams params,
  ) {
    return _repository.getNearbyStations(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
