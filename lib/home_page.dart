import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(child: Text(l10n.homeShellMessage)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          final routes = [
            RouteConstants.measure,
            RouteConstants.fields,
            RouteConstants.map,
            RouteConstants.settings,
          ];
          context.go(routes[index]);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.straighten),
            label: l10n.measure,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: l10n.myFields,
          ),
          BottomNavigationBarItem(icon: const Icon(Icons.map), label: l10n.map),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
