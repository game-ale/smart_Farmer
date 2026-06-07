import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/core/gis/unit_converter.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';
import 'package:smart_gps_area/features/field_measurement/domain/usecases/save_field_usecase.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/bloc/measurement/measurement_bloc.dart';
import 'package:smart_gps_area/injection/injection_container.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, this.measurementState});

  final Object? measurementState;

  @override
  Widget build(BuildContext context) {
    final state = measurementState;
    if (state is! MeasurementState || state.points.length < 3) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: const Center(child: Text('No measurement data available.')),
      );
    }

    final converter = getIt<UnitConverter>();
    final areaSqMeters = state.areaSqMeters;
    final perimeterMeters = state.perimeterMeters;

    return Scaffold(
      appBar: AppBar(title: const Text('Measurement Results')),
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
                      'Measurement Complete',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\${state.points.length} boundary points recorded',
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
              'Area',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _UnitCard(
              icon: Icons.square_foot,
              label: 'Square Meters',
              value: areaSqMeters.toStringAsFixed(2),
              unit: 'm²',
            ),
            _UnitCard(
              icon: Icons.landscape,
              label: 'Hectares',
              value: converter.toHectares(areaSqMeters).toStringAsFixed(4),
              unit: 'ha',
            ),
            _UnitCard(
              icon: Icons.terrain,
              label: 'Acres',
              value: converter.toAcres(areaSqMeters).toStringAsFixed(4),
              unit: 'ac',
            ),
            _UnitCard(
              icon: Icons.grid_on,
              label: 'Timad',
              value: converter.toTimad(areaSqMeters).toStringAsFixed(4),
              unit: 'timad',
            ),
            _UnitCard(
              icon: Icons.grid_view,
              label: 'Kert',
              value: converter.toKert(areaSqMeters).toStringAsFixed(2),
              unit: 'kert',
            ),

            const SizedBox(height: 16),

            // Perimeter
            Text(
              'Perimeter',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _UnitCard(
              icon: Icons.straighten,
              label: 'Perimeter',
              value: perimeterMeters.toStringAsFixed(2),
              unit: 'm',
            ),

            const SizedBox(height: 24),

            // Actions
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('SAVE FIELD'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _showSaveDialog(context, state),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('DISCARD'),
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
                  'Save Measurement',
                  style: Theme.of(bottomSheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Field Name',
                    hintText: 'e.g. North Farm Plot',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a field name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('SAVE'),
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
                              content: Text(
                                'Field "\${field.name}" saved successfully!',
                              ),
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
