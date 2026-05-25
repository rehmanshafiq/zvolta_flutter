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
import 'package:zvolta_flutter/data/datasources/home_datasource.dart';
import 'package:zvolta_flutter/data/repositories/home_repository_impl.dart';
import 'package:zvolta_flutter/domain/repositories/home_repository.dart';
import 'package:zvolta_flutter/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:zvolta_flutter/data/datasources/bookings_datasource.dart';
import 'package:zvolta_flutter/data/datasources/charge_sessions_datasource.dart';
import 'package:zvolta_flutter/data/repositories/bookings_repository_impl.dart';
import 'package:zvolta_flutter/data/repositories/charge_sessions_repository_impl.dart';
import 'package:zvolta_flutter/domain/repositories/bookings_repository.dart';
import 'package:zvolta_flutter/domain/repositories/charge_sessions_repository.dart';
import 'package:zvolta_flutter/domain/usecases/get_bookings_usecase.dart';
import 'package:zvolta_flutter/domain/usecases/get_charge_sessions_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/bookings/bookings_bloc.dart';
import 'package:zvolta_flutter/data/repositories/map_repository_impl.dart';
import 'package:zvolta_flutter/domain/repositories/map_repository.dart';
import 'package:zvolta_flutter/domain/usecases/get_nearby_stations_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/charge_sessions/charge_sessions_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/home/home_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/splash/splash_bloc.dart';

final sl = GetIt.instance;

/// Registers all dependencies with get_it.
Future<void> configureDependencies() async {
  await GetStorage.init();

  sl
    ..registerLazySingleton(ErrorParser.new)
    ..registerLazySingleton<GetStorage>(() => GetStorage())
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        errorParser: sl(),
        getToken: () => sl<GetStorage>().read<String>(AppConstants.authTokenKey),
      ),
    );

  sl.registerLazySingleton(() => AppApiService(sl()));

  sl
    ..registerLazySingleton<AppRemoteDataSource>(
      () => AppRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AppLocalDataSource>(
      () => AppLocalDataSourceImpl(sl()),
    );

  sl.registerLazySingleton<AppRepository>(
    () => AppRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl
    ..registerLazySingleton(() => CheckAppInitializedUseCase(sl()))
    ..registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new)
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetHomeDashboardUseCase(sl()))
    ..registerLazySingleton<ChargeSessionsLocalDataSource>(
      ChargeSessionsLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<ChargeSessionsRepository>(
      () => ChargeSessionsRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetChargeSessionsUseCase(sl()))
    ..registerLazySingleton<BookingsLocalDataSource>(
      BookingsLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<BookingsRepository>(
      () => BookingsRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetBookingsUseCase(sl()))
    ..registerLazySingleton<MapRepository>(MapRepositoryImpl.new)
    ..registerLazySingleton(() => GetNearbyStationsUseCase(sl()));

  sl
    ..registerFactory(() => SplashBloc(checkAppInitializedUseCase: sl()))
    ..registerFactory(() => HomeBloc(getHomeDashboardUseCase: sl()))
    ..registerFactory(() => ChargeSessionsBloc(getChargeSessionsUseCase: sl()))
    ..registerFactory(() => BookingsBloc(getBookingsUseCase: sl()))
    ..registerFactory<MapBloc>(
      () => MapBloc(getNearbyStationsUseCase: sl()),
    )
    ..registerFactory(BottomNavBloc.new);
}
