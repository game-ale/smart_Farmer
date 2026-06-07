import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  bool hasSavedLanguage();

  AppSettings loadSettings();

  Future<void> saveSettings(AppSettings settings);
}
