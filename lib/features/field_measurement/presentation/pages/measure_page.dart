import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class MeasurePage extends StatelessWidget {
  const MeasurePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.measurementMode)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.howToMeasure,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _MeasurementModeCard(
              title: l10n.gpsMeasurement,
              description: l10n.gpsMeasurementDesc,
              icon: Icons.directions_walk,
              color: Colors.blue,
              onTap: () => context.push(RouteConstants.gpsMeasurement),
            ),
            const SizedBox(height: 16),
            _MeasurementModeCard(
              title: l10n.manualMeasurement,
              description: l10n.manualMeasurementDesc,
              icon: Icons.touch_app,
              color: Colors.green,
              onTap: () => context.push(RouteConstants.manualMeasurement),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementModeCard extends StatelessWidget {
  const _MeasurementModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 32, color: color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
