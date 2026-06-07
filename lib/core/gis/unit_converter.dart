import 'package:smart_gps_area/core/constants/unit_constants.dart';

class UnitConverter {
  const UnitConverter();

  double toHectares(double squareMeters) =>
      squareMeters / UnitConstants.squareMetersPerHectare;

  double toAcres(double squareMeters) =>
      squareMeters / UnitConstants.squareMetersPerAcre;

  double toTimad(double squareMeters) =>
      squareMeters / UnitConstants.squareMetersPerTimad;

  double toKert(double squareMeters) =>
      squareMeters / UnitConstants.squareMetersPerKert;
}
