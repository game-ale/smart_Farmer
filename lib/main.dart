import 'package:flutter/widgets.dart';
import 'package:smart_gps_area/app.dart';
import 'package:smart_gps_area/core/storage/hive_config.dart';
import 'package:smart_gps_area/injection/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<HiveConfig>().initialize();
  runApp(const SmartGpsAreaApp());
}
