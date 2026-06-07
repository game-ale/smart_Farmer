import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class SettingsStarted extends SettingsEvent {
  const SettingsStarted({this.deviceLocale});

  final Locale? deviceLocale;

  @override
  List<Object?> get props => [deviceLocale];
}

final class SettingsLanguageChanged extends SettingsEvent {
  const SettingsLanguageChanged(this.language);

  final SupportedLanguage language;

  @override
  List<Object?> get props => [language];
}

final class SettingsThemeModeChanged extends SettingsEvent {
  const SettingsThemeModeChanged(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

final class SettingsDefaultUnitChanged extends SettingsEvent {
  const SettingsDefaultUnitChanged(this.unit);

  final AreaUnit unit;

  @override
  List<Object?> get props => [unit];
}
