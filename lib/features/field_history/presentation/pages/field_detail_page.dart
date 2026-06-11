import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_gps_area/core/gis/offline_tile_provider.dart';
import 'package:smart_gps_area/core/gis/unit_converter.dart';
import 'package:smart_gps_area/features/field_history/domain/usecases/field_usecases.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';
import 'package:smart_gps_area/injection/injection_container.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class FieldDetailPage extends StatefulWidget {
  const FieldDetailPage({required this.fieldId, super.key});

  final String fieldId;

  @override
  State<FieldDetailPage> createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  FieldEntity? _field;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadField();
  }

  Future<void> _loadField() async {
    final useCase = getIt<GetFieldByIdUseCase>();
    final field = await useCase(widget.fieldId);
    setState(() {
      _field = field;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.fieldDetail)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final field = _field;
    if (field == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.fieldDetail)),
        body: Center(child: Text(l10n.fieldNotFound)),
      );
    }

    final converter = getIt<UnitConverter>();
    final points = field.points
        .map((c) => LatLng(c.latitude, c.longitude))
        .toList();

    // Calculate center of the polygon for map centering
    double avgLat = 0, avgLng = 0;
    for (final p in points) {
      avgLat += p.latitude;
      avgLng += p.longitude;
    }
    avgLat /= points.length;
    avgLng /= points.length;

    return Scaffold(
      appBar: AppBar(title: Text(field.name)),
      body: Column(
        children: [
          // Map preview
          SizedBox(
            height: 250,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(avgLat, avgLng),
                initialZoom: 17.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.gameale.smart_farmer',
                  tileProvider: OfflineTileProvider(),
                ),
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
              ],
            ),
          ),

          // Details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    field.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.measuredOn('${field.createdAt.day}/${field.createdAt.month}/${field.createdAt.year}'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Unit cards
                  _DetailRow(
                    label: l10n.unitSquareMeters,
                    value: '${field.areaSqMeters.toStringAsFixed(2)} ${l10n.unitShortSqm}',
                  ),
                  _DetailRow(
                    label: l10n.unitHectares,
                    value:
                        '${converter.toHectares(field.areaSqMeters).toStringAsFixed(4)} ${l10n.unitShortHa}',
                  ),
                  _DetailRow(
                    label: l10n.unitAcres,
                    value:
                        '${converter.toAcres(field.areaSqMeters).toStringAsFixed(4)} ${l10n.unitShortAcre}',
                  ),
                  _DetailRow(
                    label: l10n.unitTimad,
                    value:
                        '${converter.toTimad(field.areaSqMeters).toStringAsFixed(4)} ${l10n.unitShortTimad}',
                  ),
                  _DetailRow(
                    label: l10n.unitKert,
                    value:
                        '${converter.toKert(field.areaSqMeters).toStringAsFixed(2)} ${l10n.unitShortKert}',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: l10n.perimeter,
                    value: '${field.perimeterMeters.toStringAsFixed(2)} m',
                  ),
                  _DetailRow(
                    label: l10n.boundaryPoints,
                    value: '${field.points.length}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
