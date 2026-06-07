import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/core/gis/offline_tile_provider.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/bloc/gps/gps_bloc.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/bloc/measurement/measurement_bloc.dart';
import 'package:smart_gps_area/injection/injection_container.dart';

class GpsMeasurementPage extends StatefulWidget {
  const GpsMeasurementPage({super.key});

  @override
  State<GpsMeasurementPage> createState() => _GpsMeasurementPageState();
}

class _GpsMeasurementPageState extends State<GpsMeasurementPage> {
  final MapController _mapController = MapController();
  final GpsBloc _gpsBloc = getIt<GpsBloc>();
  final MeasurementBloc _measurementBloc = getIt<MeasurementBloc>();

  bool _isAutoPause = false;

  @override
  void initState() {
    super.initState();
    _gpsBloc.add(const GpsStarted());
  }

  @override
  void dispose() {
    _gpsBloc.add(const GpsStopped());
    _gpsBloc.close();
    _measurementBloc.close();
    _mapController.dispose();
    super.dispose();
  }

  void _onGpsStateChanged(BuildContext context, GpsState state) {
    if (state is GpsAccurate) {
      // Auto resume if it was auto paused
      if (_isAutoPause) {
        _measurementBloc.add(const MeasurementResumed());
        _isAutoPause = false;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('GPS Signal restored. Resumed.')),
          );
      }

      // Pass coordinate to measurement bloc
      _measurementBloc.add(MeasurementCoordinateReceived(state.coordinate));

      // Auto center map
      _mapController.move(
        LatLng(state.coordinate.latitude, state.coordinate.longitude),
        _mapController.camera.zoom,
      );
    } else if (state is GpsInaccurate || state is GpsSignalLost) {
      final measState = _measurementBloc.state;
      if (measState.status == MeasurementStatus.active) {
        _measurementBloc.add(const MeasurementPaused());
        _isAutoPause = true;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Poor GPS Accuracy. Measurement Auto-Paused.'),
              backgroundColor: Colors.orange,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _gpsBloc),
        BlocProvider.value(value: _measurementBloc),
      ],
      child: BlocListener<GpsBloc, GpsState>(
        listener: _onGpsStateChanged,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('GPS Measurement'),
            actions: [const _AccuracyBadge()],
          ),
          body: Stack(children: [_buildMap(), _buildMeasurementOverlay()]),
          bottomNavigationBar: _buildBottomControls(),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        return BlocBuilder<GpsBloc, GpsState>(
          builder: (context, gpsState) {
            final points = state.points
                .map((c) => LatLng(c.latitude, c.longitude))
                .toList();

            LatLng? currentLoc;
            if (gpsState is GpsAccurate) {
              currentLoc = LatLng(
                gpsState.coordinate.latitude,
                gpsState.coordinate.longitude,
              );
            } else if (gpsState is GpsInaccurate) {
              currentLoc = LatLng(
                gpsState.coordinate.latitude,
                gpsState.coordinate.longitude,
              );
            }

            return FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(9.03, 38.74),
                initialZoom: 16.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.gameale.smart_farmer',
                  tileProvider: OfflineTileProvider(),
                ),
                if (points.isNotEmpty)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: points,
                        color: Colors.blue.withValues(alpha: 0.3),
                        borderColor: Colors.blue,
                        borderStrokeWidth: 2.0,
                        isFilled: true,
                      ),
                    ],
                  ),
                if (currentLoc != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLoc,
                        width: 24,
                        height: 24,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMeasurementOverlay() {
    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        if (state.points.isEmpty) return const SizedBox.shrink();

        return Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Area',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('\${state.areaSqMeters.toStringAsFixed(2)} m²'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Points',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('\${state.points.length}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == MeasurementStatus.idle)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('START WALKING'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      _measurementBloc.add(const MeasurementStarted());
                      _isAutoPause = false;
                    },
                  )
                else if (state.status == MeasurementStatus.active ||
                    state.status == MeasurementStatus.paused) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(
                            state.status == MeasurementStatus.active
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            state.status == MeasurementStatus.active
                                ? 'PAUSE'
                                : 'RESUME',
                          ),
                          onPressed: () {
                            if (state.status == MeasurementStatus.active) {
                              _measurementBloc.add(const MeasurementPaused());
                              _isAutoPause =
                                  false; // Manual pause overrides auto
                            } else {
                              _measurementBloc.add(const MeasurementResumed());
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.undo),
                          label: const Text('UNDO'),
                          onPressed: state.points.isEmpty
                              ? null
                              : () => _measurementBloc.add(
                                  const MeasurementUndoLastPoint(),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('FINISH'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: state.points.length >= 3
                        ? () {
                            _measurementBloc.add(const MeasurementFinished());
                            context.push(RouteConstants.results);
                          }
                        : null, // Disabled if < 3 points
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccuracyBadge extends StatelessWidget {
  const _AccuracyBadge();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        Color color = Colors.grey;
        String text = 'Waiting';

        if (state is GpsAccurate) {
          color = Colors.green;
          text = 'Good (\${state.coordinate.accuracy?.toStringAsFixed(1)}m)';
        } else if (state is GpsInaccurate) {
          color = Colors.orange;
          text = 'Poor (\${state.coordinate.accuracy?.toStringAsFixed(1)}m)';
        } else if (state is GpsSignalLost) {
          color = Colors.red;
          text = 'Lost';
        } else if (state is GpsPermissionDenied) {
          color = Colors.red;
          text = 'No Permission';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
