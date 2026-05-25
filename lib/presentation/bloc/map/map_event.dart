import 'package:equatable/equatable.dart';

enum MapViewMode { map, list }

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

final class MapStationsRequested extends MapEvent {
  const MapStationsRequested();
}

final class MapRefreshRequested extends MapEvent {
  const MapRefreshRequested();
}

final class MapViewModeChanged extends MapEvent {
  const MapViewModeChanged(this.mode);

  final MapViewMode mode;

  @override
  List<Object?> get props => [mode];
}

final class MapSearchQueryChanged extends MapEvent {
  const MapSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class MapNearMeRequested extends MapEvent {
  const MapNearMeRequested();
}

final class MapFavoriteToggled extends MapEvent {
  const MapFavoriteToggled(this.stationId);

  final String stationId;

  @override
  List<Object?> get props => [stationId];
}

final class MapStationSelected extends MapEvent {
  const MapStationSelected(this.stationId);

  final String stationId;

  @override
  List<Object?> get props => [stationId];
}
