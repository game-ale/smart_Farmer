# Smart GPS Fields Area Measure

Offline-first GPS field area measurement app for Ethiopian smallholder farmers.

## Phase One Status

Phase one establishes the project setup and architecture shell from the product documentation:

- Flutter Android app configured as `smart_gps_area`
- Clean Architecture feature folders for data, domain, and presentation layers
- Core folders for constants, error handling, GIS helpers, storage, theme, router, utilities, and shared widgets
- `get_it` dependency container with phase-one services registered
- Hive initialization for local preferences storage
- GoRouter route table with named routes for all roadmap screens
- Light and dark Material 3 theme foundations with large tap targets
- GitHub Actions CI for analyze, format, test, and release APK build

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
