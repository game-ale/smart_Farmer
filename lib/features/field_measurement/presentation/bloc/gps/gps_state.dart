part of 'gps_bloc.dart';

sealed class GpsState extends Equatable {
  const GpsState();

  @override
  List<Object?> get props => [];
}

final class GpsInitial extends GpsState {
  const GpsInitial();
}

final class GpsPermissionDenied extends GpsState {
  const GpsPermissionDenied();
}

final class GpsAccurate extends GpsState {
  const GpsAccurate({required this.coordinate});
  final Coordinate coordinate;

  @override
  List<Object?> get props => [coordinate];
}

final class GpsInaccurate extends GpsState {
  const GpsInaccurate({required this.coordinate});
  final Coordinate coordinate;

  @override
  List<Object?> get props => [coordinate];
}

final class GpsSignalLost extends GpsState {
  const GpsSignalLost();
}
