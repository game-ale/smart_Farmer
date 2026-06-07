import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:smart_gps_area/features/map_view/domain/repositories/map_repository.dart';
import 'package:smart_gps_area/features/map_view/domain/usecases/download_map_area_usecase.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required this.downloadMapArea, required this.mapRepository})
    : super(const MapInitial()) {
    on<MapDownloadAreaRequested>(_onDownloadAreaRequested);
    on<MapClearCacheRequested>(_onClearCacheRequested);
    on<MapCacheSizeRequested>(_onCacheSizeRequested);
  }

  final DownloadMapAreaUseCase downloadMapArea;
  final MapRepository mapRepository;

  Future<void> _onDownloadAreaRequested(
    MapDownloadAreaRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapDownloading(progress: 0.0));

    try {
      await emit.forEach<double>(
        downloadMapArea(event.bounds, event.minZoom, event.maxZoom),
        onData: (progress) {
          if (progress >= 1.0) {
            return const MapReady(message: 'Download complete');
          }
          return MapDownloading(progress: progress);
        },
        onError: (error, stackTrace) => MapError(message: error.toString()),
      );

      // Ensure we hit ready state if stream ends normally without yielding exactly 1.0
      if (state is MapDownloading) {
        emit(const MapReady(message: 'Download complete'));
      }
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }

  Future<void> _onClearCacheRequested(
    MapClearCacheRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      await mapRepository.clearCache();
      emit(const MapReady(message: 'Cache cleared successfully'));
    } catch (e) {
      emit(MapError(message: 'Failed to clear cache: $e'));
    }
  }

  Future<void> _onCacheSizeRequested(
    MapCacheSizeRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final size = await mapRepository.getCacheSize();
      // Emitting the same ready state with a different message isn't great architecture,
      // but for simplicity we'll just log or use it if needed in the UI.
      // Usually size would be a property of the state.
      if (state is MapReady) {
        emit((state as MapReady).copyWith(cacheSizeBytes: size));
      } else {
        emit(MapReady(cacheSizeBytes: size));
      }
    } catch (e) {
      emit(MapError(message: 'Failed to get cache size: $e'));
    }
  }
}
