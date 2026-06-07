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

## Phase Three Status

Phase three implements the Map Integration and Offline capabilities:
- Custom `OfflineTileProvider` wrapping `path_provider` and `dart:io` for caching OpenStreetMap tiles.
- 200MB LRU background eviction policy implemented directly in the tile provider.
- Interactive `MapPage` built using `flutter_map` v6.
- Real-time GPS dot rendering using `geolocator` stream.
- Concurrent bounding box tile downloader to save visible areas for offline use.
- `MapBloc` implemented to manage download states and cache clear events.
- Dependencies kept to an absolute minimum by utilizing custom Dart IO solutions.

## Phase Four Status

Phase four implements the core GPS Field Measurement functionality:
- `Coordinate` domain model introduced for strict mapping.
- `GpsBloc` implemented to strictly monitor stream accuracy, transitioning between `GpsAccurate` (≤ 5m), `GpsInaccurate` (> 5m), and `GpsSignalLost`.
- `MeasurementBloc` tracks real-time walking sessions, applying a 3-meter distance filter before appending coordinates to the polygon.
- Advanced mapping mathematics powered by `maps_toolkit` for live spherical area (m²) and perimeter (m) calculations during walks.
- Interactive `GpsMeasurementPage` with an Accuracy Badge overlay, Live Polygon Drawing, Auto-Pause mechanisms on poor GPS signal, and Undo controls.

## Phase Five Status

Phase five implements the Manual Measurement Map functionality:
- `MeasurementBloc` expanded to handle manual point additions, deletions, and clear all events.
- `ManualMeasurementPage` utilizes `FlutterMap`'s `onTap` coordinate projection to instantly drop precision points.
- Interactive custom map markers that support immediate tap-to-delete.
- Real-time `maps_toolkit` calculation overlay, identical to the GPS flow.
- Intuitive "Undo" and "Clear All" controls for rapid boundary sketching.

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
