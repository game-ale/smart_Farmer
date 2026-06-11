import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_gps_area/core/gis/offline_tile_provider.dart';
import 'package:smart_gps_area/features/map_view/presentation/bloc/map_bloc.dart';
import 'package:smart_gps_area/injection/injection_container.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        return;
      }
    }

    // Get initial position
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = pos);
      // Center map on initial position
      _mapController.move(LatLng(pos.latitude, pos.longitude), 15.0);
    } catch (_) {}

    // Listen to stream
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 2, // meters
          ),
        ).listen((Position position) {
          if (mounted) {
            setState(() => _currentPosition = position);
          }
        });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _centerOnMe() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        16.0,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.waitingForGps)),
      );
    }
  }

  void _downloadVisibleArea(BuildContext blocContext) {
    final bounds = _mapController.camera.visibleBounds;
    // Download zoom levels from current up to 18
    final minZoom = _mapController.camera.zoom.floor();
    const maxZoom = 18;

    blocContext.read<MapBloc>().add(
      MapDownloadAreaRequested(
        bounds: bounds,
        minZoom: minZoom,
        maxZoom: maxZoom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MapBloc>(),
      child: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapReady && state.message != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message!)));
          } else if (state is MapError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.map),
              actions: [
                IconButton(
                  icon: const Icon(Icons.download),
                  tooltip: AppLocalizations.of(context)!.downloadOffline,
                  onPressed: state is MapDownloading
                      ? null
                      : () => _downloadVisibleArea(context),
                ),
              ],
            ),
            body: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    // Default center (Addis Ababa)
                    initialCenter: const LatLng(9.03, 38.74),
                    initialZoom: 12.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.gameale.smart_farmer',
                      tileProvider: OfflineTileProvider(),
                    ),
                    if (_currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            width: 24,
                            height: 24,
                            child: const _PulsingLocationMarker(),
                          ),
                        ],
                      ),
                  ],
                ),
                if (state is MapDownloading)
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 80,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppLocalizations.of(context)!.downloadingMap),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(value: state.progress),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _centerOnMe,
              child: const Icon(Icons.my_location),
            ),
          );
        },
      ),
    );
  }
}

class _PulsingLocationMarker extends StatefulWidget {
  const _PulsingLocationMarker();

  @override
  State<_PulsingLocationMarker> createState() => _PulsingLocationMarkerState();
}

class _PulsingLocationMarkerState extends State<_PulsingLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withValues(alpha: 0.3 * _animation.value),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
        );
      },
    );
  }
}
