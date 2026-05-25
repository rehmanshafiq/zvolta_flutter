import 'package:zvolta_flutter/core/utils/exception_mapper.dart';
import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/data/datasources/home_datasource.dart';
import 'package:zvolta_flutter/domain/entities/home_dashboard_entity.dart';
import 'package:zvolta_flutter/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeLocalDataSource localDataSource,
    ExceptionMapper exceptionMapper = const ExceptionMapper(),
  })  : _localDataSource = localDataSource,
        _exceptionMapper = exceptionMapper;

  final HomeLocalDataSource _localDataSource;
  final ExceptionMapper _exceptionMapper;

  @override
  Future<Result<HomeDashboardEntity>> getHomeDashboard() async {
    try {
      final dashboard = await _localDataSource.getHomeDashboard();
      return Success(dashboard.toEntity());
    } catch (error) {
      return Error(_exceptionMapper.map(error));
    }
  }
}
