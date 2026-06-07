sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class CacheException extends AppException {
  const CacheException(super.message);
}

final class LocationException extends AppException {
  const LocationException(super.message);
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}
