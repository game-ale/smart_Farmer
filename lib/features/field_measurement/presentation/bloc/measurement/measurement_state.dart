part of 'measurement_bloc.dart';

enum MeasurementStatus { idle, active, paused, complete }

class MeasurementState extends Equatable {
  const MeasurementState({
    required this.status,
    this.points = const [],
    this.areaSqMeters = 0.0,
    this.perimeterMeters = 0.0,
  });

  final MeasurementStatus status;
  final List<Coordinate> points;
  final double areaSqMeters;
  final double perimeterMeters;

  MeasurementState copyWith({
    MeasurementStatus? status,
    List<Coordinate>? points,
    double? areaSqMeters,
    double? perimeterMeters,
  }) {
    return MeasurementState(
      status: status ?? this.status,
      points: points ?? this.points,
      areaSqMeters: areaSqMeters ?? this.areaSqMeters,
      perimeterMeters: perimeterMeters ?? this.perimeterMeters,
    );
  }

  @override
  List<Object?> get props => [status, points, areaSqMeters, perimeterMeters];
}
