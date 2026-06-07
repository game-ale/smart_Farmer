import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/core/widgets/large_button.dart';

class MeasurePage extends StatelessWidget {
  const MeasurePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Measure')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LargeButton(
            label: 'GPS Measurement',
            icon: Icons.gps_fixed,
            onPressed: () => context.go(RouteConstants.gpsMeasurement),
          ),
          const SizedBox(height: 16),
          LargeButton(
            label: 'Manual Measurement',
            icon: Icons.touch_app,
            onPressed: () => context.go(RouteConstants.manualMeasurement),
          ),
        ],
      ),
    ),
  );
}
