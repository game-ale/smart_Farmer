import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';
import 'package:smart_gps_area/features/settings/domain/repositories/settings_repository.dart';
import 'package:smart_gps_area/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:smart_gps_area/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_event.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_state.dart';

class FakeSettingsRepository implements SettingsRepository {
  AppSettings _settings = const AppSettings.defaults();
  bool _hasSavedLanguage = false;

  @override
  bool hasSavedLanguage() => _hasSavedLanguage;

  @override
  AppSettings loadSettings() => _settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    _hasSavedLanguage = true;
  }
}

void main() {
  late FakeSettingsRepository fakeRepository;
  late GetSettingsUseCase getSettingsUseCase;
  late SaveSettingsUseCase saveSettingsUseCase;
  late SettingsBloc bloc;

  setUp(() {
    fakeRepository = FakeSettingsRepository();
    getSettingsUseCase = GetSettingsUseCase(fakeRepository);
    saveSettingsUseCase = SaveSettingsUseCase(fakeRepository);
    bloc = SettingsBloc(
      getSettings: getSettingsUseCase,
      saveSettings: saveSettingsUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is correct', () {
    expect(bloc.state.status, SettingsStatus.initial);
    expect(bloc.state.settings, const AppSettings.defaults());
  });

  test('SettingsLanguageChanged updates language', () async {
    bloc.add(const SettingsLanguageChanged(SupportedLanguage.amharic));

    // Wait for event to be processed
    await Future.delayed(Duration.zero);

    expect(bloc.state.settings.language, SupportedLanguage.amharic);
    expect(fakeRepository.loadSettings().language, SupportedLanguage.amharic);
  });

  test('SettingsThemeModeChanged updates theme mode', () async {
    bloc.add(const SettingsThemeModeChanged(ThemeMode.dark));

    await Future.delayed(Duration.zero);

    expect(bloc.state.settings.themeMode, ThemeMode.dark);
    expect(fakeRepository.loadSettings().themeMode, ThemeMode.dark);
  });

  test('SettingsDefaultUnitChanged updates default unit', () async {
    bloc.add(const SettingsDefaultUnitChanged(AreaUnit.hectares));

    await Future.delayed(Duration.zero);

    expect(bloc.state.settings.defaultAreaUnit, AreaUnit.hectares);
    expect(fakeRepository.loadSettings().defaultAreaUnit, AreaUnit.hectares);
  });
}
