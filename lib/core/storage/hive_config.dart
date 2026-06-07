import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_gps_area/core/storage/hive_box_names.dart';
import 'package:smart_gps_area/features/field_history/data/models/coordinate_model.dart';
import 'package:smart_gps_area/features/field_history/data/models/field_model.dart';

class HiveConfig {
  const HiveConfig();

  Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(FieldModelAdapter());
    Hive.registerAdapter(CoordinateModelAdapter());

    // Open boxes
    await Hive.openBox<Object>(HiveBoxNames.preferences);
    await Hive.openBox<FieldModel>(HiveBoxNames.fields);
  }
}
