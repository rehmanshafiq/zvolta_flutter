import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_event.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

final class MapInitial extends MapState {
  const MapInitial();
}

final class MapLoading extends MapState {
  const MapLoading();
}

final class MapLoaded extends MapState {
  const MapLoaded({
    required this.stations,
    required this.userLocation,
    required this.viewMode,
    required this.searchQuery,
    this.selectedStationId,
  });

  final List<ChargingStationEntity> stations;
  final LatLng userLocation;
  final MapViewMode viewMode;
  final String searchQuery;
  final String? selectedStationId;

  List<ChargingStationEntity> get filteredStations {
    if (searchQuery.trim().isEmpty) return stations;

    final query = searchQuery.toLowerCase();
    return stations
        .where(
          (station) =>
              station.name.toLowerCase().contains(query) ||
              station.address.toLowerCase().contains(query),
        )
        .toList();
  }

  MapLoaded copyWith({
    List<ChargingStationEntity>? stations,
    LatLng? userLocation,
    MapViewMode? viewMode,
    String? searchQuery,
    String? selectedStationId,
    bool clearSelection = false,
  }) {
    return MapLoaded(
      stations: stations ?? this.stations,
      userLocation: userLocation ?? this.userLocation,
      viewMode: viewMode ?? this.viewMode,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStationId:
          clearSelection ? null : (selectedStationId ?? this.selectedStationId),
    );
  }

  @override
  List<Object?> get props => [
        stations,
        userLocation,
        viewMode,
        searchQuery,
        selectedStationId,
      ];
}

final class MapFailure extends MapState {
  const MapFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
