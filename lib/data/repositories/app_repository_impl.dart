import 'package:zvolta_flutter/core/utils/exception_mapper.dart';
import 'package:zvolta_flutter/core/utils/result.dart';
import 'package:zvolta_flutter/data/datasources/app_datasource.dart';
import 'package:zvolta_flutter/domain/entities/app_init_status.dart';
import 'package:zvolta_flutter/domain/entities/user_entity.dart';
import 'package:zvolta_flutter/domain/repositories/app_repository.dart';

/// Concrete implementation of [AppRepository].
/// Coordinates remote/local data sources and maps models to entities.
class AppRepositoryImpl implements AppRepository {
  AppRepositoryImpl({
    required AppRemoteDataSource remoteDataSource,
    required AppLocalDataSource localDataSource,
    ExceptionMapper exceptionMapper = const ExceptionMapper(),
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _exceptionMapper = exceptionMapper;

  final AppRemoteDataSource _remoteDataSource;
  final AppLocalDataSource _localDataSource;
  final ExceptionMapper _exceptionMapper;

  @override
  Future<Result<AppInitStatus>> checkAppInitialized() async {
    try {
      final isFirstLaunch = await _localDataSource.isFirstLaunch();

      if (isFirstLaunch) {
        await _localDataSource.setFirstLaunchCompleted();
      }

      return Success(
        AppInitStatus(
          isInitialized: true,
          isFirstLaunch: isFirstLaunch,
        ),
      );
    } catch (error) {
      return Error(_exceptionMapper.map(error));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      return Success(users.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Error(_exceptionMapper.map(error));
    }
  }
}
