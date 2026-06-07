import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:smart_gps_area/core/gis/coordinate.dart';

class AreaCalculator {
  const AreaCalculator();

  double calculateAreaSquareMeters(List<Coordinate> points) {
    if (points.length < 3) return 0.0;
    final latLngs = points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    // SphericalUtil.computeArea returns area in square meters
    return SphericalUtil.computeArea(latLngs).toDouble();
  }

  double calculatePerimeterMeters(List<Coordinate> points) {
    if (points.length < 2) return 0.0;
    final latLngs = points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    // To get perimeter of a closed polygon, compute length and include the closing segment
    final length = SphericalUtil.computeLength(latLngs).toDouble();
    if (points.length > 2) {
      final closingDistance = SphericalUtil.computeDistanceBetween(
        latLngs.last,
        latLngs.first,
      ).toDouble();
      return length + closingDistance;
    }
    return length;
  }
}
