import 'package:smart_gps_area/core/gis/coordinate.dart';

abstract interface class GpsRepository {
  /// Stream of GPS coordinates representing the user's location.
  Stream<Coordinate> getPositionStream();

  /// Requests permissions and checks if GPS services are enabled.
  Future<bool> requestPermission();

  /// Checks current accuracy, returning true if it's within the threshold (e.g., <= 5m)
  Future<bool> isAccuracyGood({double threshold = 5.0});
}
