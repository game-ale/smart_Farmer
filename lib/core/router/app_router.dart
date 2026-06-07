import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/features/field_history/presentation/pages/field_detail_page.dart';
import 'package:smart_gps_area/features/field_history/presentation/pages/field_list_page.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/pages/gps_measurement_page.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/pages/manual_measurement_page.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/pages/measure_page.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/pages/results_page.dart';
import 'package:smart_gps_area/features/map_view/presentation/pages/map_page.dart';
import 'package:smart_gps_area/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:smart_gps_area/features/onboarding/presentation/pages/splash_page.dart';
import 'package:smart_gps_area/features/settings/presentation/pages/language_selection_page.dart';
import 'package:smart_gps_area/features/settings/presentation/pages/settings_page.dart';
import 'package:smart_gps_area/home_page.dart';

final class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteConstants.measure,
        builder: (context, state) => const MeasurePage(),
      ),
      GoRoute(
        path: RouteConstants.gpsMeasurement,
        builder: (context, state) => const GpsMeasurementPage(),
      ),
      GoRoute(
        path: RouteConstants.manualMeasurement,
        builder: (context, state) => const ManualMeasurementPage(),
      ),
      GoRoute(
        path: RouteConstants.results,
        builder: (context, state) => const ResultsPage(),
      ),
      GoRoute(
        path: RouteConstants.fields,
        builder: (context, state) => const FieldListPage(),
      ),
      GoRoute(
        path: RouteConstants.fieldDetail,
        builder: (_, state) =>
            FieldDetailPage(fieldId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: RouteConstants.map,
        builder: (context, state) => const MapPage(),
      ),
      GoRoute(
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteConstants.language,
        builder: (context, state) => const LanguageSelectionPage(),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(child: Text(state.error?.message ?? 'Route not found')),
    ),
  );
}
