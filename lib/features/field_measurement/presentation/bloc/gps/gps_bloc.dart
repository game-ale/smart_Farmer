import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_gps_area/core/gis/coordinate.dart';
import 'package:smart_gps_area/features/field_measurement/domain/repositories/gps_repository.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  GpsBloc({required this.gpsRepository}) : super(const GpsInitial()) {
    on<GpsStarted>(_onStarted);
    on<GpsCoordinateReceived>(_onCoordinateReceived);
    on<GpsLost>(_onLost);
    on<GpsStopped>(_onStopped);
  }

  final GpsRepository gpsRepository;
  StreamSubscription<Coordinate>? _gpsSubscription;
  Timer? _lostTimer;

  static const double accuracyThreshold = 5.0; // meters

  Future<void> _onStarted(GpsStarted event, Emitter<GpsState> emit) async {
    final hasPermission = await gpsRepository.requestPermission();
    if (!hasPermission) {
      emit(const GpsPermissionDenied());
      return;
    }

    _gpsSubscription?.cancel();
    _gpsSubscription = gpsRepository.getPositionStream().listen(
      (coordinate) {
        add(GpsCoordinateReceived(coordinate));
      },
      onError: (e) {
        add(const GpsLost());
      },
    );
  }

  void _onCoordinateReceived(
    GpsCoordinateReceived event,
    Emitter<GpsState> emit,
  ) {
    // Reset lost timer on every new coordinate
    _lostTimer?.cancel();
    _lostTimer = Timer(const Duration(seconds: 10), () {
      add(const GpsLost());
    });

    final accuracy = event.coordinate.accuracy ?? double.infinity;
    if (accuracy <= accuracyThreshold) {
      emit(GpsAccurate(coordinate: event.coordinate));
    } else {
      emit(GpsInaccurate(coordinate: event.coordinate));
    }
  }

  void _onLost(GpsLost event, Emitter<GpsState> emit) {
    emit(const GpsSignalLost());
  }

  void _onStopped(GpsStopped event, Emitter<GpsState> emit) {
    _gpsSubscription?.cancel();
    _lostTimer?.cancel();
    emit(const GpsInitial());
  }

  @override
  Future<void> close() {
    _gpsSubscription?.cancel();
    _lostTimer?.cancel();
    return super.close();
  }
}
