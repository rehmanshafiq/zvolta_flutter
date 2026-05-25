import 'package:get_storage/get_storage.dart';
import 'package:zvolta_flutter/core/constants/app_constants.dart';
import 'package:zvolta_flutter/data/models/user_model.dart';
import 'package:zvolta_flutter/data/services/app_api_service.dart';

/// Remote data source — talks to API services only.
abstract class AppRemoteDataSource {
  Future<List<UserModel>> getUsers();
}

class AppRemoteDataSourceImpl implements AppRemoteDataSource {
  AppRemoteDataSourceImpl(this._apiService);

  final AppApiService _apiService;

  @override
  Future<List<UserModel>> getUsers() => _apiService.fetchUsers();
}

/// Local data source — handles cached preferences and tokens.
abstract class AppLocalDataSource {
  Future<bool> isFirstLaunch();

  Future<void> setFirstLaunchCompleted();
}

class AppLocalDataSourceImpl implements AppLocalDataSource {
  AppLocalDataSourceImpl(this._storage);

  final GetStorage _storage;

  @override
  Future<bool> isFirstLaunch() async {
    return _storage.read<bool>(AppConstants.isFirstLaunchKey) ?? true;
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    await _storage.write(AppConstants.isFirstLaunchKey, false);
  }
}
