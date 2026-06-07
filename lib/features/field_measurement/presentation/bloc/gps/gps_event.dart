part of 'gps_bloc.dart';

sealed class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object?> get props => [];
}

final class GpsStarted extends GpsEvent {
  const GpsStarted();
}

final class GpsStopped extends GpsEvent {
  const GpsStopped();
}

final class GpsCoordinateReceived extends GpsEvent {
  const GpsCoordinateReceived(this.coordinate);
  final Coordinate coordinate;

  @override
  List<Object?> get props => [coordinate];
}

final class GpsLost extends GpsEvent {
  const GpsLost();
}
