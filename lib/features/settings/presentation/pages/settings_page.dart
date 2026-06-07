import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go(RouteConstants.language),
        ),
        const ListTile(
          leading: Icon(Icons.dark_mode),
          title: Text('Dark mode'),
          subtitle: Text('Implemented in Phase 2.'),
        ),
      ],
    ),
  );
}
