import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SupportedLanguage {
  english('en', 'English', 'English', '🇺🇸'),
  afanOromo('om', 'Afan Oromo', 'Afaan Oromoo', '🇪🇹'),
  amharic('am', 'Amharic', 'አማርኛ', '🇪🇹');

  const SupportedLanguage(
    this.code,
    this.englishName,
    this.nativeName,
    this.flag,
  );

  final String code;
  final String englishName;
  final String nativeName;
  final String flag;

  Locale get locale => Locale(code);

  static SupportedLanguage fromCode(String? code) =>
      SupportedLanguage.values.firstWhere(
        (language) => language.code == code,
        orElse: () => SupportedLanguage.english,
      );
}

enum AreaUnit {
  squareMeters('sqm'),
  hectares('ha'),
  mide('mide');

  const AreaUnit(this.code);

  final String code;

  static AreaUnit fromCode(String? code) => AreaUnit.values.firstWhere(
    (unit) => unit.code == code,
    orElse: () => AreaUnit.squareMeters,
  );
}

class AppSettings extends Equatable {
  const AppSettings({
    required this.language,
    required this.themeMode,
    required this.defaultAreaUnit,
  });

  const AppSettings.defaults()
    : language = SupportedLanguage.english,
      themeMode = ThemeMode.system,
      defaultAreaUnit = AreaUnit.squareMeters;

  final SupportedLanguage language;
  final ThemeMode themeMode;
  final AreaUnit defaultAreaUnit;

  AppSettings copyWith({
    SupportedLanguage? language,
    ThemeMode? themeMode,
    AreaUnit? defaultAreaUnit,
  }) => AppSettings(
    language: language ?? this.language,
    themeMode: themeMode ?? this.themeMode,
    defaultAreaUnit: defaultAreaUnit ?? this.defaultAreaUnit,
  );

  @override
  List<Object?> get props => [language, themeMode, defaultAreaUnit];
}
