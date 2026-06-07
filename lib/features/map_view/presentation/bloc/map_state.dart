part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

final class MapInitial extends MapState {
  const MapInitial();
}

final class MapDownloading extends MapState {
  const MapDownloading({required this.progress});

  final double progress; // 0.0 to 1.0

  @override
  List<Object?> get props => [progress];
}

final class MapReady extends MapState {
  const MapReady({this.message, this.cacheSizeBytes});

  final String? message;
  final int? cacheSizeBytes;

  MapReady copyWith({String? message, int? cacheSizeBytes}) {
    return MapReady(
      message: message ?? this.message,
      cacheSizeBytes: cacheSizeBytes ?? this.cacheSizeBytes,
    );
  }

  @override
  List<Object?> get props => [message, cacheSizeBytes];
}

final class MapError extends MapState {
  const MapError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
