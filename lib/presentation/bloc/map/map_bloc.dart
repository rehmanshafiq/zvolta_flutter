import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zvolta_flutter/data/datasources/map_datasource.dart';
import 'package:zvolta_flutter/domain/usecases/get_nearby_stations_usecase.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_event.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required GetNearbyStationsUseCase getNearbyStationsUseCase})
      : _getNearbyStationsUseCase = getNearbyStationsUseCase,
        super(const MapInitial()) {
    on<MapStationsRequested>(_onStationsRequested);
    on<MapRefreshRequested>(_onStationsRequested);
    on<MapViewModeChanged>(_onViewModeChanged);
    on<MapSearchQueryChanged>(_onSearchQueryChanged);
    on<MapNearMeRequested>(_onNearMeRequested);
    on<MapFavoriteToggled>(_onFavoriteToggled);
    on<MapStationSelected>(_onStationSelected);
  }

  final GetNearbyStationsUseCase _getNearbyStationsUseCase;

  Future<void> _onStationsRequested(
    MapEvent event,
    Emitter<MapState> emit,
  ) async {
    final current = state;
    if (current is! MapLoaded) {
      emit(const MapLoading());
    }

    final location = current is MapLoaded
        ? current.userLocation
        : await _resolveUserLocation();

    final result = await _getNearbyStationsUseCase(
      GetNearbyStationsParams(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    );

    if (result.isError) {
      emit(MapFailure(message: result.failureOrNull!.message));
      return;
    }

    final stations = result.dataOrNull ?? [];
    final previous = current is MapLoaded ? current : null;

    emit(
      MapLoaded(
        stations: stations,
        userLocation: location,
        viewMode: previous?.viewMode ?? MapViewMode.map,
        searchQuery: previous?.searchQuery ?? '',
        selectedStationId: previous?.selectedStationId,
      ),
    );
  }

  void _onViewModeChanged(
    MapViewModeChanged event,
    Emitter<MapState> emit,
  ) {
    final current = state;
    if (current is! MapLoaded) return;
    emit(current.copyWith(viewMode: event.mode));
  }

  void _onSearchQueryChanged(
    MapSearchQueryChanged event,
    Emitter<MapState> emit,
  ) {
    final current = state;
    if (current is! MapLoaded) return;
    emit(current.copyWith(searchQuery: event.query));
  }

  Future<void> _onNearMeRequested(
    MapNearMeRequested event,
    Emitter<MapState> emit,
  ) async {
    final current = state;
    if (current is! MapLoaded) return;

    emit(const MapLoading());

    final location = await _resolveUserLocation();

    final result = await _getNearbyStationsUseCase(
      GetNearbyStationsParams(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    );

    if (result.isError) {
      emit(MapFailure(message: result.failureOrNull!.message));
      return;
    }

    emit(
      current.copyWith(
        stations: result.dataOrNull ?? [],
        userLocation: location,
        clearSelection: true,
      ),
    );
  }

  void _onFavoriteToggled(
    MapFavoriteToggled event,
    Emitter<MapState> emit,
  ) {
    final current = state;
    if (current is! MapLoaded) return;

    final updated = current.stations.map((station) {
      if (station.id != event.stationId) return station;
      return station.copyWith(isFavorite: !station.isFavorite);
    }).toList();

    emit(current.copyWith(stations: updated));
  }

  void _onStationSelected(
    MapStationSelected event,
    Emitter<MapState> emit,
  ) {
    final current = state;
    if (current is! MapLoaded) return;
    emit(current.copyWith(selectedStationId: event.stationId));
  }

  Future<LatLng> _resolveUserLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          return const LatLng(
            MapLocalDataSource.defaultLatitude,
            MapLocalDataSource.defaultLongitude,
          );
        }
      }

      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return const LatLng(
        MapLocalDataSource.defaultLatitude,
        MapLocalDataSource.defaultLongitude,
      );
    }
  }
}
