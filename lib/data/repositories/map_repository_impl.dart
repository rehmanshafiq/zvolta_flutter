import 'package:zvolta_flutter/core/utils/exception_mapper.dart';
import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/data/datasources/map_datasource.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';
import 'package:zvolta_flutter/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  MapRepositoryImpl({
    MapLocalDataSource? localDataSource,
    ExceptionMapper exceptionMapper = const ExceptionMapper(),
  })  : _localDataSource = localDataSource ?? MapLocalDataSource(),
        _exceptionMapper = exceptionMapper;

  final MapLocalDataSource _localDataSource;
  final ExceptionMapper _exceptionMapper;

  @override
  Future<Result<List<ChargingStationEntity>>> getNearbyStations({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final stations = await _localDataSource.getNearbyStations(
        latitude: latitude,
        longitude: longitude,
      );
      return Success(stations.map((station) => station.toEntity()).toList());
    } catch (error) {
      return Error(_exceptionMapper.map(error));
    }
  }
}
