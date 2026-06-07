class CoordinateUtils {
  const CoordinateUtils._();

  static bool isValidLatitude(double latitude) =>
      latitude >= -90 && latitude <= 90;

  static bool isValidLongitude(double longitude) =>
      longitude >= -180 && longitude <= 180;
}
