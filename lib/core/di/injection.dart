import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zvolta_flutter/core/constants/app_constants.dart';
import 'package:zvolta_flutter/core/network/api_client.dart';
import 'package:zvolta_flutter/core/network/error_parser.dart';
import 'package:zvolta_flutter/data/datasources/app_datasource.dart';
import 'package:zvolta_flutter/data/repositories/app_repository_impl.dart';
import 'package:zvolta_flutter/data/services/app_api_service.dart';
import 'package:zvolta_flutter/domain/repositories/app_repository.dart';
import 'package:zvolta_flutter/domain/usecases/check_app_initialized_usecase.dart';
import 'package:zvolta_flutter/domain/usecases/get_users_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/splash/splash_bloc.dart';

final sl = GetIt.instance;

/// Registers all dependencies with get_it.
/// Call once before runApp().
Future<void> configureDependencies() async {
  await GetStorage.init();

  // Core
  sl
    ..registerLazySingleton(ErrorParser.new)
    ..registerLazySingleton<GetStorage>(() => GetStorage())
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        errorParser: sl(),
        getToken: () => sl<GetStorage>().read<String>(AppConstants.authTokenKey),
      ),
    );

  // Services
  sl.registerLazySingleton(() => AppApiService(sl()));

  // Data sources
  sl
    ..registerLazySingleton<AppRemoteDataSource>(
      () => AppRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AppLocalDataSource>(
      () => AppLocalDataSourceImpl(sl()),
    );

  // Repositories
  sl.registerLazySingleton<AppRepository>(
    () => AppRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl
    ..registerLazySingleton(() => CheckAppInitializedUseCase(sl()))
    ..registerLazySingleton(() => GetUsersUseCase(sl()));

  // Blocs — factory so each screen gets a fresh instance
  sl
    ..registerFactory(() => SplashBloc(checkAppInitializedUseCase: sl()))
    ..registerFactory(() => HomeBloc(getUsersUseCase: sl()))
    ..registerFactory(BottomNavBloc.new);
}
