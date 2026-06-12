import 'package:smart_gps_area/core/constants/unit_constants.dart';

class UnitConverter {
  const UnitConverter();

  double toHectares(double squareMeters) =>
      squareMeters / UnitConstants.squareMetersPerHectare;

  double toMide(double squareMeters) =>
      squareMeters / UnitConstants.squareMetersPerMide;
}
