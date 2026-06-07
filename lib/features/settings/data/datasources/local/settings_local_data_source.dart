import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_gps_area/core/storage/hive_box_names.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource({HiveInterface? hive}) : _hive = hive ?? Hive;

  static const _languageCodeKey = 'language_code';
  static const _themeModeKey = 'theme_mode';
  static const _defaultAreaUnitKey = 'default_area_unit';

  final HiveInterface _hive;

  Box<Object> get _box => _hive.box<Object>(HiveBoxNames.preferences);

  bool hasSavedLanguage() => _box.containsKey(_languageCodeKey);

  AppSettings loadSettings() {
    final storedLanguage = _box.get(_languageCodeKey) as String?;
    final storedThemeMode = _box.get(_themeModeKey) as String?;
    final storedAreaUnit = _box.get(_defaultAreaUnitKey) as String?;

    return AppSettings(
      language: SupportedLanguage.fromCode(storedLanguage),
      themeMode: _themeModeFromName(storedThemeMode),
      defaultAreaUnit: AreaUnit.fromCode(storedAreaUnit),
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _box.put(_languageCodeKey, settings.language.code);
    await _box.put(_themeModeKey, settings.themeMode.name);
    await _box.put(_defaultAreaUnitKey, settings.defaultAreaUnit.code);
  }

  ThemeMode _themeModeFromName(String? name) => ThemeMode.values.firstWhere(
    (mode) => mode.name == name,
    orElse: () => ThemeMode.system,
  );
}
