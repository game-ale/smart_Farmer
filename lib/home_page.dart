import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Smart GPS Fields Area Measure')),
    body: const Center(child: Text('Project architecture shell')),
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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.straighten), label: 'Measure'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'My Fields'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    ),
  );
}
