import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';
import 'package:smart_gps_area/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:smart_gps_area/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_event.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSettingsUseCase getSettings,
    required SaveSettingsUseCase saveSettings,
  }) : _getSettings = getSettings,
       _saveSettings = saveSettings,
       super(const SettingsState.initial()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsLanguageChanged>(_onLanguageChanged);
    on<SettingsThemeModeChanged>(_onThemeModeChanged);
    on<SettingsDefaultUnitChanged>(_onDefaultUnitChanged);
  }

  final GetSettingsUseCase _getSettings;
  final SaveSettingsUseCase _saveSettings;

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    try {
      var settings = _getSettings();
      final detectedLanguage = _detectLanguage(event.deviceLocale);

      if (!_getSettings.hasSavedLanguage &&
          detectedLanguage != SupportedLanguage.english) {
        settings = settings.copyWith(language: detectedLanguage);
        await _saveSettings(settings);
      }

      emit(SettingsState(status: SettingsStatus.loaded, settings: settings));
    } on Object {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: 'Could not load settings.',
        ),
      );
    }
  }

  Future<void> _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _saveAndEmit(state.settings.copyWith(language: event.language), emit);
  }

  Future<void> _onThemeModeChanged(
    SettingsThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _saveAndEmit(
      state.settings.copyWith(themeMode: event.themeMode),
      emit,
    );
  }

  Future<void> _onDefaultUnitChanged(
    SettingsDefaultUnitChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _saveAndEmit(
      state.settings.copyWith(defaultAreaUnit: event.unit),
      emit,
    );
  }

  Future<void> _saveAndEmit(
    AppSettings settings,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _saveSettings(settings);
      emit(SettingsState(status: SettingsStatus.loaded, settings: settings));
    } on Object {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: 'Could not save settings.',
        ),
      );
    }
  }

  SupportedLanguage _detectLanguage(Locale? locale) =>
      SupportedLanguage.fromCode(locale?.languageCode);
}
