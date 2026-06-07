import 'package:get_it/get_it.dart';
import 'package:smart_gps_area/core/gis/area_calculator.dart';
import 'package:smart_gps_area/core/gis/unit_converter.dart';
import 'package:smart_gps_area/core/router/app_router.dart';
import 'package:smart_gps_area/core/storage/hive_config.dart';
import 'package:smart_gps_area/features/settings/data/datasources/local/settings_local_data_source.dart';
import 'package:smart_gps_area/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:smart_gps_area/features/settings/domain/repositories/settings_repository.dart';
import 'package:smart_gps_area/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:smart_gps_area/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:smart_gps_area/injection/injection_container.config.dart';

import 'package:smart_gps_area/features/map_view/data/repositories/map_repository_impl.dart';
import 'package:smart_gps_area/features/map_view/domain/repositories/map_repository.dart';
import 'package:smart_gps_area/features/map_view/domain/usecases/download_map_area_usecase.dart';
import 'package:smart_gps_area/features/map_view/presentation/bloc/map_bloc.dart';

import 'package:smart_gps_area/features/field_measurement/data/repositories/gps_repository_impl.dart';
import 'package:smart_gps_area/features/field_measurement/domain/repositories/gps_repository.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/bloc/gps/gps_bloc.dart';
import 'package:smart_gps_area/features/field_measurement/presentation/bloc/measurement/measurement_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton(AppRouter.new);
  getIt.registerLazySingleton(HiveConfig.new);
  getIt.registerLazySingleton(AreaCalculator.new);
  getIt.registerLazySingleton(UnitConverter.new);
  getIt.registerLazySingleton(SettingsLocalDataSource.new);
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => GetSettingsUseCase(getIt()));
  getIt.registerFactory(() => SaveSettingsUseCase(getIt()));
  getIt.registerFactory(
    () => SettingsBloc(getSettings: getIt(), saveSettings: getIt()),
  );

  // Map feature
  getIt.registerLazySingleton<MapRepository>(() => MapRepositoryImpl());
  getIt.registerFactory(() => DownloadMapAreaUseCase(getIt()));
  getIt.registerFactory(
    () => MapBloc(downloadMapArea: getIt(), mapRepository: getIt()),
  );

  // Field Measurement (GPS) feature
  getIt.registerLazySingleton<GpsRepository>(() => GpsRepositoryImpl());
  getIt.registerFactory(() => GpsBloc(gpsRepository: getIt()));
  getIt.registerFactory(() => MeasurementBloc(areaCalculator: getIt()));

  getIt.init();
}
