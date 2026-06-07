import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:smart_gps_area/core/gis/coordinate.dart';
import 'package:smart_gps_area/features/field_measurement/domain/repositories/gps_repository.dart';

class GpsRepositoryImpl implements GpsRepository {
  @override
  Stream<Coordinate> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0, // We want continuous updates for accuracy monitoring
      ),
    ).map(
      (position) => Coordinate(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> isAccuracyGood({double threshold = 5.0}) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
      return position.accuracy <= threshold;
    } catch (_) {
      return false;
    }
  }
}
