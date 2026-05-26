import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/domain/entities/charging_station_entity.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_bloc.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_event.dart';
import 'package:zvolta_flutter/presentation/bloc/map/map_state.dart';
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
  _MapFilters _filters = _MapFilters.initial();
  BitmapDescriptor? _userLocationIcon;

  @override
  void initState() {
    super.initState();
    _loadUserLocationIcon();
  }

  Future<void> _loadUserLocationIcon() async {
    final icon = await _createUserLocationIcon();
    if (mounted) {
      setState(() => _userLocationIcon = icon);
    }
  }

  Future<BitmapDescriptor> _createUserLocationIcon() async {
    const size = 48.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);

    canvas.drawCircle(
      center,
      20,
      Paint()..color = AppColors.mapPinBlueColor.withValues(alpha: 0.18),
    );
    canvas.drawCircle(
      center,
      10,
      Paint()..color = AppColors.whiteColor,
    );
    canvas.drawCircle(
      center,
      8,
      Paint()..color = AppColors.mapPinBlueColor,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(
      byteData!.buffer.asUint8List(),
      width: size,
      height: size,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers(
    List<ChargingStationEntity> stations,
    LatLng userLocation,
  ) {
    final markers = stations.map((station) {
      return Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.latitude, station.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () => context.read<MapBloc>().add(
              MapStationSelected(station.id),
            ),
      );
    }).toSet();

    if (_userLocationIcon != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: userLocation,
          icon: _userLocationIcon!,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 2,
        ),
      );
    }

    return markers;
  }

  List<ChargingStationEntity> _applyFilters(
    List<ChargingStationEntity> stations,
  ) {
    return stations.where((station) {
      if (_filters.favoriteOnly && !station.isFavorite) return false;

      if (_filters.capacitiesKw.isNotEmpty &&
          !_filters.capacitiesKw.contains(station.powerKw.toDouble())) {
        return false;
      }

      if (_filters.connectorTypes.isNotEmpty) {
        final stationConnectors =
            station.connectorType == StationConnectorType.ac
                ? const {'CSS2', 'Universal'}
                : const {'CCS2', 'CCS'};
        final hasConnectorMatch = _filters.connectorTypes.any(
          stationConnectors.contains,
        );
        if (!hasConnectorMatch) return false;
      }

      if (_filters.priceRangeActive &&
          (station.sellPricePkr < _filters.priceRange.start ||
              station.sellPricePkr > _filters.priceRange.end)) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> _openFilterSheet() async {
    final selectedFilters = await showModalBottomSheet<_MapFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MapFilterBottomSheet(initialFilters: _filters),
    );

    if (selectedFilters != null && mounted) {
      setState(() => _filters = selectedFilters);
    }
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
            final filteredStations = state is MapLoaded
                ? _applyFilters(state.filteredStations)
                : <ChargingStationEntity>[];

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
                      filteredStations: filteredStations,
                      onFilterTap: _openFilterSheet,
                      onBookTap: _onBookTap,
                    )
                  : _MapModeView(
                      state: state,
                      filteredStations: filteredStations,
                      markers: _buildMarkers(
                        filteredStations,
                        state.userLocation,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      onZoomIn: () => _mapController?.animateCamera(
                        CameraUpdate.zoomIn(),
                      ),
                      onZoomOut: () => _mapController?.animateCamera(
                        CameraUpdate.zoomOut(),
                      ),
                      onMyLocation: () => _animateToUser(state.userLocation),
                      onFilterTap: _openFilterSheet,
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
    required this.filteredStations,
    required this.markers,
    required this.onMapCreated,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
    required this.onFilterTap,
    required this.onBookTap,
  });

  final MapLoaded state;
  final List<ChargingStationEntity> filteredStations;
  final Set<Marker> markers;
  final ValueChanged<GoogleMapController> onMapCreated;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;
  final VoidCallback onFilterTap;
  final ValueChanged<ChargingStationEntity> onBookTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: state.userLocation,
            zoom: 12,
          ),
          markers: markers,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: onMapCreated,
        ),
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: Column(
            children: [
              MapSearchBar(
                onChanged: (query) => bloc.add(MapSearchQueryChanged(query)),
                onFilterTap: onFilterTap,
              ),
              const SizedBox(height: 10),
              MapViewToggle(
                selectedMode: state.viewMode,
                onModeChanged: (mode) => bloc.add(MapViewModeChanged(mode)),
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
            stations: filteredStations,
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
    required this.filteredStations,
    required this.onFilterTap,
    required this.onBookTap,
  });

  final MapLoaded state;
  final List<ChargingStationEntity> filteredStations;
  final VoidCallback onFilterTap;
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
                onChanged: (query) => bloc.add(MapSearchQueryChanged(query)),
                onFilterTap: onFilterTap,
              ),
              const SizedBox(height: 10),
              MapViewToggle(
                selectedMode: state.viewMode,
                onModeChanged: (mode) => bloc.add(MapViewModeChanged(mode)),
                onNearMeTap: () => bloc.add(const MapNearMeRequested()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NearbyStationsList(
            stations: filteredStations,
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

class _MapFilters {
  const _MapFilters({
    required this.connectorTypes,
    required this.favoriteOnly,
    required this.capacitiesKw,
    required this.priceRange,
    required this.priceRangeActive,
    required this.amenities,
  });

  factory _MapFilters.initial() {
    return const _MapFilters(
      connectorTypes: {},
      favoriteOnly: false,
      capacitiesKw: {},
      priceRange: RangeValues(0, 150),
      priceRangeActive: false,
      amenities: {},
    );
  }

  final Set<String> connectorTypes;
  final bool favoriteOnly;
  final Set<double> capacitiesKw;
  final RangeValues priceRange;
  final bool priceRangeActive;
  final Set<String> amenities;

  _MapFilters copyWith({
    Set<String>? connectorTypes,
    bool? favoriteOnly,
    Set<double>? capacitiesKw,
    RangeValues? priceRange,
    bool? priceRangeActive,
    Set<String>? amenities,
  }) {
    return _MapFilters(
      connectorTypes: connectorTypes ?? this.connectorTypes,
      favoriteOnly: favoriteOnly ?? this.favoriteOnly,
      capacitiesKw: capacitiesKw ?? this.capacitiesKw,
      priceRange: priceRange ?? this.priceRange,
      priceRangeActive: priceRangeActive ?? this.priceRangeActive,
      amenities: amenities ?? this.amenities,
    );
  }
}

class _MapFilterBottomSheet extends StatefulWidget {
  const _MapFilterBottomSheet({required this.initialFilters});

  final _MapFilters initialFilters;

  @override
  State<_MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();
}

class _MapFilterBottomSheetState extends State<_MapFilterBottomSheet> {
  static const _connectorTypes = ['CSS2', 'Universal', 'CCS2', 'CCS'];
  static const _capacitiesKw = [7.0, 3.3, 30.0, 22.0];
  static const _amenities = [
    (label: 'WiFi', icon: Icons.wifi_rounded),
    (label: 'Washroom', icon: Icons.home_outlined),
    (label: 'Masjid', icon: Icons.apartment_rounded),
    (label: 'Tuck Shop', icon: Icons.local_mall_outlined),
  ];

  late _MapFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters.copyWith(
      connectorTypes: {...widget.initialFilters.connectorTypes},
      capacitiesKw: {...widget.initialFilters.capacitiesKw},
      amenities: {...widget.initialFilters.amenities},
    );
  }

  void _toggleConnector(String connector) {
    final connectors = {..._filters.connectorTypes};
    connectors.contains(connector)
        ? connectors.remove(connector)
        : connectors.add(connector);
    setState(() => _filters = _filters.copyWith(connectorTypes: connectors));
  }

  void _toggleCapacity(double capacity) {
    final capacities = {..._filters.capacitiesKw};
    capacities.contains(capacity)
        ? capacities.remove(capacity)
        : capacities.add(capacity);
    setState(() => _filters = _filters.copyWith(capacitiesKw: capacities));
  }

  void _toggleAmenity(String amenity) {
    final amenities = {..._filters.amenities};
    amenities.contains(amenity)
        ? amenities.remove(amenity)
        : amenities.add(amenity);
    setState(() => _filters = _filters.copyWith(amenities: amenities));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return FractionallySizedBox(
      heightFactor: 0.86,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 5,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: AppColors.greyBottomSheetThumbColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(
                            () => _filters = _MapFilters.initial(),
                          ),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppColors.homeIconGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const _FilterSectionTitle('Connector Type'),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _connectorTypes.map((connector) {
                        return _FilterChipButton(
                          label: connector,
                          icon: Icons.bolt_rounded,
                          selected: _filters.connectorTypes.contains(connector),
                          onTap: () => _toggleConnector(connector),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    const _FilterSectionTitle('Favourite'),
                    const SizedBox(height: 14),
                    _FilterChipButton(
                      label: 'Favourite',
                      icon: Icons.favorite_border_rounded,
                      selected: _filters.favoriteOnly,
                      onTap: () => setState(
                        () => _filters = _filters.copyWith(
                          favoriteOnly: !_filters.favoriteOnly,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _FilterSectionTitle('Charging Capacity'),
                    const SizedBox(height: 12),
                    ..._capacitiesKw.map(
                      (capacity) => _CapacityCheckboxTile(
                        label: _formatCapacity(capacity),
                        selected: _filters.capacitiesKw.contains(capacity),
                        onTap: () => _toggleCapacity(capacity),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                          child: _FilterSectionTitle('Price Range (PKR/kWh)'),
                        ),
                        Text(
                          '${_filters.priceRange.start.round()} - ${_filters.priceRange.end.round()}',
                          style: const TextStyle(
                            color: AppColors.greyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      min: 0,
                      max: 150,
                      divisions: 15,
                      values: _filters.priceRange,
                      activeColor: AppColors.homeIconGreen,
                      inactiveColor: AppColors.dividerColor,
                      onChanged: (values) => setState(
                        () => _filters = _filters.copyWith(
                          priceRange: values,
                          priceRangeActive: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _FilterSectionTitle('Amenities'),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 3.7,
                      children: _amenities.map((amenity) {
                        return _AmenityButton(
                          label: amenity.label,
                          icon: amenity.icon,
                          selected: _filters.amenities.contains(amenity.label),
                          onTap: () => _toggleAmenity(amenity.label),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(24, 14, 24, bottomPadding + 14),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(
                  top: BorderSide(
                    color: AppColors.blackColor.withValues(alpha: 0.08),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.splashBackground,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(_filters),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCapacity(double capacity) {
    return capacity == capacity.roundToDouble()
        ? '${capacity.round()} kW'
        : '$capacity kW';
  }
}

class _FilterSectionTitle extends StatelessWidget {
  const _FilterSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.blackColor,
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.homeIconGreen : AppColors.blackColor;

    return Material(
      color: selected
          ? AppColors.homeIconGreen.withValues(alpha: 0.08)
          : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppColors.homeIconGreen
                  : AppColors.colorsOutlineColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapacityCheckboxTile extends StatelessWidget {
  const _CapacityCheckboxTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color:
                    selected ? AppColors.homeIconGreen : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: selected
                      ? AppColors.homeIconGreen
                      : AppColors.homeCardBorder,
                  width: 1.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.homeIconGreen.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.whiteColor,
                      size: 20,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmenityButton extends StatelessWidget {
  const _AmenityButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.homeIconGreen : AppColors.blackColor;

    return Material(
      color: selected
          ? AppColors.homeIconGreen.withValues(alpha: 0.08)
          : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.homeIconGreen
                  : AppColors.colorsOutlineColor,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
