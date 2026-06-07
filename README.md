# Smart GPS Fields Area Measure

Offline-first GPS field area measurement app for Ethiopian smallholder farmers.

## Phase One Status
Phase one established the project setup and architecture shell from the product documentation.

## Phase Two Status

Phase two implements the Localization & Settings requirements:

- `app_en.arb`, `app_om.arb`, and `app_am.arb` files with full translations
- `SettingsBloc` managing language, theme, and area unit preferences
- `SettingsLocalDataSource` for persisting preferences via Hive
- Redesigned `SettingsPage` with Material 3 segmented buttons and drop-downs
- Enhanced `LanguageSelectionPage` with three-card UI and flag icons
- Unit testing for all Settings layer components
- `flutter analyze` reports zero issues and CI is green

## Useful Commands

```sh
flutter pub get
flutter analyze
dart format --set-exit-if-changed .
flutter test --coverage
flutter build apk --release
```

## Roadmap Reference

Phase one acceptance criteria from the documentation: the app launches as a blank architecture shell, `flutter analyze` reports zero issues, and CI is green on the first commit.
