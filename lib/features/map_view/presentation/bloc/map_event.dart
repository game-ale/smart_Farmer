part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class MapDownloadAreaRequested extends MapEvent {
  const MapDownloadAreaRequested({
    required this.bounds,
    required this.minZoom,
    required this.maxZoom,
  });

  final LatLngBounds bounds;
  final int minZoom;
  final int maxZoom;

  @override
  List<Object> get props => [bounds, minZoom, maxZoom];
}

final class MapClearCacheRequested extends MapEvent {
  const MapClearCacheRequested();
}

final class MapCacheSizeRequested extends MapEvent {
  const MapCacheSizeRequested();
}
