import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gps_area/core/storage/hive_box_names.dart';

class HiveConfig {
  const HiveConfig();

  Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<Object>(HiveBoxNames.preferences);
  }
}
