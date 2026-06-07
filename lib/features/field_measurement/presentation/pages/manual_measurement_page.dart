import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/core/gis/coordinate.dart';
import 'package:smart_gps_area/core/gis/offline_tile_provider.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/bloc/measurement/measurement_bloc.dart';
import 'package:smart_gps_area/injection/injection_container.dart';

class ManualMeasurementPage extends StatefulWidget {
  const ManualMeasurementPage({super.key});

  @override
  State<ManualMeasurementPage> createState() => _ManualMeasurementPageState();
}

class _ManualMeasurementPageState extends State<ManualMeasurementPage> {
  final MapController _mapController = MapController();
  final MeasurementBloc _measurementBloc = getIt<MeasurementBloc>();

  @override
  void dispose() {
    _measurementBloc.close();
    _mapController.dispose();
    super.dispose();
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    // Add point where user tapped
    _measurementBloc.add(
      MeasurementManualPointAdded(
        Coordinate(latitude: point.latitude, longitude: point.longitude),
      ),
    );
  }

  void _handlePointDelete(int index) {
    _measurementBloc.add(MeasurementManualPointDeleted(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _measurementBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Manual Measurement')),
        body: Stack(children: [_buildMap(), _buildMeasurementOverlay()]),
        bottomNavigationBar: _buildBottomControls(),
      ),
    );
  }

  Widget _buildMap() {
    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        final points = state.points
            .map((c) => LatLng(c.latitude, c.longitude))
            .toList();

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(9.03, 38.74),
            initialZoom: 16.0,
            maxZoom: 18.0,
            onTap: _handleMapTap,
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
            MarkerLayer(
              markers: points.asMap().entries.map((entry) {
                final index = entry.key;
                final point = entry.value;
                return Marker(
                  point: point,
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _handlePointDelete(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMeasurementOverlay() {
    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        if (state.points.isEmpty) {
          return Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tap anywhere on the map to add a boundary point. Tap a point to delete it.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        }

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
                Row(
                  children: [
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_sweep),
                        label: const Text('CLEAR ALL'),
                        onPressed: state.points.isEmpty
                            ? null
                            : () => _measurementBloc.add(
                                const MeasurementClearAll(),
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
            ),
          ),
        );
      },
    );
  }
}
