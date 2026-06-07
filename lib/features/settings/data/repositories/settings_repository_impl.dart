import 'package:smart_gps_area/features/settings/data/datasources/local/settings_local_data_source.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';
import 'package:smart_gps_area/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  bool hasSavedLanguage() => _localDataSource.hasSavedLanguage();

  @override
  AppSettings loadSettings() => _localDataSource.loadSettings();

  @override
  Future<void> saveSettings(AppSettings settings) =>
      _localDataSource.saveSettings(settings);
}
