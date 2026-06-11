import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/core/gis/unit_converter.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';
import 'package:smart_gps_area/features/field_measurement/domain/usecases/save_field_usecase.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/bloc/measurement/measurement_bloc.dart';
import 'package:smart_gps_area/injection/injection_container.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, this.measurementState});

  final Object? measurementState;

  @override
  Widget build(BuildContext context) {
    final state = measurementState;
    final l10n = AppLocalizations.of(context)!;
    if (state is! MeasurementState || state.points.length < 3) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.results)),
        body: Center(child: Text(l10n.noMeasurementData)),
      );
    }

    final converter = getIt<UnitConverter>();
    final areaSqMeters = state.areaSqMeters;
    final perimeterMeters = state.perimeterMeters;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.measurementResults)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.measurementComplete,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.boundaryPointsRecorded(state.points.length),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Area in all 5 units
            Text(
              l10n.area,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _UnitCard(
              icon: Icons.square_foot,
              label: l10n.unitSquareMeters,
              value: areaSqMeters.toStringAsFixed(2),
              unit: l10n.unitShortSqm,
            ),
            _UnitCard(
              icon: Icons.landscape,
              label: l10n.unitHectares,
              value: converter.toHectares(areaSqMeters).toStringAsFixed(4),
              unit: l10n.unitShortHa,
            ),
            _UnitCard(
              icon: Icons.terrain,
              label: l10n.unitAcres,
              value: converter.toAcres(areaSqMeters).toStringAsFixed(4),
              unit: l10n.unitShortAcre,
            ),
            _UnitCard(
              icon: Icons.grid_on,
              label: l10n.unitTimad,
              value: converter.toTimad(areaSqMeters).toStringAsFixed(4),
              unit: l10n.unitShortTimad,
            ),
            _UnitCard(
              icon: Icons.grid_view,
              label: l10n.unitKert,
              value: converter.toKert(areaSqMeters).toStringAsFixed(2),
              unit: l10n.unitShortKert,
            ),

            const SizedBox(height: 16),

            // Perimeter
            Text(
              l10n.perimeter,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _UnitCard(
              icon: Icons.straighten,
              label: l10n.perimeter,
              value: perimeterMeters.toStringAsFixed(2),
              unit: 'm',
            ),

            const SizedBox(height: 24),

            // Actions
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(l10n.saveField),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _showSaveDialog(context, state),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.discard),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                context.go(RouteConstants.home);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context, MeasurementState state) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.saveMeasurement,
                  style: Theme.of(bottomSheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.fieldName,
                    hintText: l10n.fieldNameHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fieldNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: Text(l10n.save),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final field = FieldEntity(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text.trim(),
                        areaSqMeters: state.areaSqMeters,
                        perimeterMeters: state.perimeterMeters,
                        points: state.points,
                        createdAt: DateTime.now(),
                      );

                      final saveUseCase = getIt<SaveFieldUseCase>();
                      await saveUseCase(field);

                      if (context.mounted) {
                        Navigator.of(bottomSheetContext).pop();
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(l10n.fieldSavedSuccess(field.name)),
                            ),
                          );
                        context.go(RouteConstants.home);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        trailing: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' $unit',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
