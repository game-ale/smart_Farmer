part of 'measurement_bloc.dart';

sealed class MeasurementEvent extends Equatable {
  const MeasurementEvent();

  @override
  List<Object?> get props => [];
}

final class MeasurementStarted extends MeasurementEvent {
  const MeasurementStarted();
}

final class MeasurementPaused extends MeasurementEvent {
  const MeasurementPaused();
}

final class MeasurementResumed extends MeasurementEvent {
  const MeasurementResumed();
}

final class MeasurementCoordinateReceived extends MeasurementEvent {
  const MeasurementCoordinateReceived(this.coordinate);
  final Coordinate coordinate;

  @override
  List<Object?> get props => [coordinate];
}

final class MeasurementUndoLastPoint extends MeasurementEvent {
  const MeasurementUndoLastPoint();
}

final class MeasurementFinished extends MeasurementEvent {
  const MeasurementFinished();
}

final class MeasurementReset extends MeasurementEvent {
  const MeasurementReset();
}
