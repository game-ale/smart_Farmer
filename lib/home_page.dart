import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
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
