import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/core/widgets/placeholder_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      if (mounted) {
        context.go(RouteConstants.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) => const PlaceholderPage(
    title: 'Splash',
    subtitle: 'Initial route configured for Phase 1.',
  );
}
