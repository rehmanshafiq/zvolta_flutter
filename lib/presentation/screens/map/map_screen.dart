import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_event.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_state.dart';
import 'package:zvolta_flutter/presentation/bloc/bottom_nav/bottom_nav_event.dart';
import 'package:zvolta_flutter/presentation/widgets/app_error_view.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';
import 'package:zvolta_flutter/presentation/widgets/map/map_search_bar.dart';
import 'package:zvolta_flutter/presentation/widgets/map/map_view_toggle.dart';
import 'package:zvolta_flutter/presentation/widgets/map/nearby_station_card.dart';

/// Map tab — find nearby charging stations.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MapBloc>()..add(const MapStationsRequested()),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  GoogleMapController? _mapController;
  bool _shouldRenderMap = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMapVisibility();
  }

  /// Avoid creating Android PlatformView while the tab is off-screen (IndexedStack).
  void _syncMapVisibility() {
    final shell = StatefulNavigationShell.maybeOf(context);
    final isMapTabActive = shell?.currentIndex == BottomNavTab.map.index;

    if (isMapTabActive && !_shouldRenderMap) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _shouldRenderMap = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers(List<ChargingStationEntity> stations) {
    return stations.map((station) {
      return Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.latitude, station.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () => context.read<MapBloc>().add(
              MapStationSelected(station.id),
            ),
      );
    }).toSet();
  }

  Future<void> _animateToUser(LatLng location) async {
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 13),
    );
  }

  void _onBookTap(ChargingStationEntity station) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking ${station.name}...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<MapBloc, MapState>(
          listenWhen: (previous, current) =>
              current is MapLoaded &&
              previous is MapLoaded &&
              previous.userLocation != current.userLocation,
          listener: (context, state) {
            if (state is MapLoaded) {
              _animateToUser(state.userLocation);
            }
          },
          builder: (context, state) {
            return switch (state) {
              MapInitial() || MapLoading() => const AppLoadingIndicator(
                  message: 'Loading stations...',
                ),
              MapFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: () =>
                      context.read<MapBloc>().add(const MapRefreshRequested()),
                ),
              MapLoaded() => state.viewMode == MapViewMode.list
                  ? _ListModeView(
                      state: state,
                      onBookTap: _onBookTap,
                    )
                  : _MapModeView(
                      state: state,
                      shouldRenderMap: _shouldRenderMap,
                      markers: _buildMarkers(state.filteredStations),
                      onMapCreated: (controller) => _mapController = controller,
                      onZoomIn: () => _mapController?.animateCamera(
                        CameraUpdate.zoomIn(),
                      ),
                      onZoomOut: () => _mapController?.animateCamera(
                        CameraUpdate.zoomOut(),
                      ),
                      onMyLocation: () => _animateToUser(state.userLocation),
                      onBookTap: _onBookTap,
                    ),
            };
          },
        ),
      ),
    );
  }
}

class _MapModeView extends StatelessWidget {
  const _MapModeView({
    required this.state,
    required this.shouldRenderMap,
    required this.markers,
    required this.onMapCreated,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
    required this.onBookTap,
  });

  final MapLoaded state;
  final bool shouldRenderMap;
  final Set<Marker> markers;
  final ValueChanged<GoogleMapController> onMapCreated;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;
  final ValueChanged<ChargingStationEntity> onBookTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();

    return Stack(
      children: [
        if (shouldRenderMap)
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.userLocation,
              zoom: 12,
            ),
            markers: markers,
            circles: {
              Circle(
                circleId: const CircleId('current_location'),
                center: state.userLocation,
                radius: 18,
                fillColor: AppColors.homeIconGreen.withValues(alpha: 0.20),
                strokeColor: AppColors.whiteColor,
                strokeWidth: 3,
              ),
              Circle(
                circleId: const CircleId('current_location_dot'),
                center: state.userLocation,
                radius: 7,
                fillColor: Colors.blueAccent,
                strokeColor: AppColors.whiteColor,
                strokeWidth: 2,
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: onMapCreated,
          )
        else
          const ColoredBox(
            color: AppColors.homeBackground,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.homeIconGreen,
              ),
            ),
          ),
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: Column(
            children: [
              MapSearchBar(
                onChanged: (query) =>
                    bloc.add(MapSearchQueryChanged(query)),
                onFilterTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filters coming soon')),
                  );
                },
              ),
              const SizedBox(height: 10),
              MapViewToggle(
                selectedMode: state.viewMode,
                onModeChanged: (mode) =>
                    bloc.add(MapViewModeChanged(mode)),
                onNearMeTap: () => bloc.add(const MapNearMeRequested()),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: 140,
          child: Column(
            children: [
              _MapControlButton(
                icon: Icons.my_location_rounded,
                onTap: onMyLocation,
              ),
              const SizedBox(height: 8),
              _MapControlButton(icon: Icons.add, onTap: onZoomIn),
              const SizedBox(height: 4),
              _MapControlButton(icon: Icons.remove, onTap: onZoomOut),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _NearbyStationsPanel(
            stations: state.filteredStations,
            onBookTap: onBookTap,
          ),
        ),
      ],
    );
  }
}

class _ListModeView extends StatelessWidget {
  const _ListModeView({
    required this.state,
    required this.onBookTap,
  });

  final MapLoaded state;
  final ValueChanged<ChargingStationEntity> onBookTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              MapSearchBar(
                onChanged: (query) =>
                    bloc.add(MapSearchQueryChanged(query)),
                onFilterTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filters coming soon')),
                  );
                },
              ),
              const SizedBox(height: 10),
              MapViewToggle(
                selectedMode: state.viewMode,
                onModeChanged: (mode) =>
                    bloc.add(MapViewModeChanged(mode)),
                onNearMeTap: () => bloc.add(const MapNearMeRequested()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NearbyStationsList(
            stations: state.filteredStations,
            onBookTap: onBookTap,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        ),
      ],
    );
  }
}

class _NearbyStationsPanel extends StatelessWidget {
  const _NearbyStationsPanel({
    required this.stations,
    required this.onBookTap,
  });

  final List<ChargingStationEntity> stations;
  final ValueChanged<ChargingStationEntity> onBookTap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.42;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.thumbBarGreyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Nearby Stations (${stations.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _NearbyStationsList(
              stations: stations,
              onBookTap: onBookTap,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyStationsList extends StatelessWidget {
  const _NearbyStationsList({
    required this.stations,
    required this.onBookTap,
    required this.padding,
  });

  final List<ChargingStationEntity> stations;
  final ValueChanged<ChargingStationEntity> onBookTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return const Center(
        child: Text(
          'No stations found',
          style: TextStyle(color: AppColors.homeSubtitleGrey),
        ),
      );
    }

    return ListView.separated(
      padding: padding,
      itemCount: stations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final station = stations[index];
        return NearbyStationCard(
          station: station,
          compact: true,
          onFavoriteTap: () => context.read<MapBloc>().add(
                MapFavoriteToggled(station.id),
              ),
          onBookTap: () => onBookTap(station),
        );
      },
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: AppColors.blackColor.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.blackColor),
        ),
      ),
    );
  }
}
