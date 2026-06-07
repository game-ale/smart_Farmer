import 'package:get_it/get_it.dart';
import 'package:smart_gps_area/core/gis/area_calculator.dart';
import 'package:smart_gps_area/core/gis/unit_converter.dart';
import 'package:smart_gps_area/core/router/app_router.dart';
import 'package:smart_gps_area/core/storage/hive_config.dart';
import 'package:smart_gps_area/injection/injection_container.config.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton(AppRouter.new);
  getIt.registerLazySingleton(HiveConfig.new);
  getIt.registerLazySingleton(AreaCalculator.new);
  getIt.registerLazySingleton(UnitConverter.new);
  getIt.init();
}
