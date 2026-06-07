import 'package:flutter_map/flutter_map.dart';

abstract interface class MapRepository {
  /// Downloads and caches tiles for a given bounding box and zoom range.
  /// Yields progress percentage (0.0 to 1.0).
  Stream<double> downloadTiles(LatLngBounds bounds, int minZoom, int maxZoom);

  /// Clears the entire offline tile cache.
  Future<void> clearCache();

  /// Returns the current size of the cache in bytes.
  Future<int> getCacheSize();
}
