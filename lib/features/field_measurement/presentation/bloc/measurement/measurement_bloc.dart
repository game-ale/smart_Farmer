import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_gps_area/core/gis/coordinate.dart';
import 'package:smart_gps_area/core/gis/area_calculator.dart';

part 'measurement_event.dart';
part 'measurement_state.dart';

class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  MeasurementBloc({required this.areaCalculator})
    : super(const MeasurementState(status: MeasurementStatus.idle)) {
    on<MeasurementStarted>(_onStarted);
    on<MeasurementPaused>(_onPaused);
    on<MeasurementResumed>(_onResumed);
    on<MeasurementCoordinateReceived>(_onCoordinateReceived);
    on<MeasurementUndoLastPoint>(_onUndoLastPoint);
    on<MeasurementFinished>(_onFinished);
    on<MeasurementReset>(_onReset);
  }

  final AreaCalculator areaCalculator;
  static const double minimumDistanceMeters = 3.0;

  void _onStarted(MeasurementStarted event, Emitter<MeasurementState> emit) {
    emit(
      const MeasurementState(
        status: MeasurementStatus.active,
        points: [],
        areaSqMeters: 0,
        perimeterMeters: 0,
      ),
    );
  }

  void _onPaused(MeasurementPaused event, Emitter<MeasurementState> emit) {
    if (state.status == MeasurementStatus.active) {
      emit(state.copyWith(status: MeasurementStatus.paused));
    }
  }

  void _onResumed(MeasurementResumed event, Emitter<MeasurementState> emit) {
    if (state.status == MeasurementStatus.paused) {
      emit(state.copyWith(status: MeasurementStatus.active));
    }
  }

  void _onCoordinateReceived(
    MeasurementCoordinateReceived event,
    Emitter<MeasurementState> emit,
  ) {
    if (state.status != MeasurementStatus.active) return;

    final newPoint = event.coordinate;
    final List<Coordinate> updatedPoints = List.from(state.points);

    if (updatedPoints.isNotEmpty) {
      final lastPoint = updatedPoints.last;
      final distance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );

      if (distance < minimumDistanceMeters) {
        // Point is too close to the last one, ignore.
        return;
      }
    }

    updatedPoints.add(newPoint);

    // Optional: Calculate live area/perimeter if enough points exist
    double area = 0;
    double perimeter = 0;
    if (updatedPoints.length >= 3) {
      area = areaCalculator.calculateAreaSquareMeters(updatedPoints);
      perimeter = areaCalculator.calculatePerimeterMeters(updatedPoints);
    }

    emit(
      state.copyWith(
        points: updatedPoints,
        areaSqMeters: area,
        perimeterMeters: perimeter,
      ),
    );
  }

  void _onUndoLastPoint(
    MeasurementUndoLastPoint event,
    Emitter<MeasurementState> emit,
  ) {
    if (state.points.isEmpty) return;

    final updatedPoints = List<Coordinate>.from(state.points)..removeLast();

    double area = 0;
    double perimeter = 0;
    if (updatedPoints.length >= 3) {
      area = areaCalculator.calculateAreaSquareMeters(updatedPoints);
      perimeter = areaCalculator.calculatePerimeterMeters(updatedPoints);
    }

    emit(
      state.copyWith(
        points: updatedPoints,
        areaSqMeters: area,
        perimeterMeters: perimeter,
      ),
    );
  }

  void _onFinished(MeasurementFinished event, Emitter<MeasurementState> emit) {
    if (state.points.length >= 3) {
      emit(state.copyWith(status: MeasurementStatus.complete));
    }
  }

  void _onReset(MeasurementReset event, Emitter<MeasurementState> emit) {
    emit(const MeasurementState(status: MeasurementStatus.idle));
  }
}
