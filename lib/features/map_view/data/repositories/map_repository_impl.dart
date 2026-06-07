import 'dart:async';
import 'dart:io';

import 'package:flutter_map/flutter_map.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:smart_gps_area/features/map_view/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final HttpClient _httpClient = HttpClient();
  // Using the standard OSM template
  final String _urlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  Stream<double> downloadTiles(
    LatLngBounds bounds,
    int minZoom,
    int maxZoom,
  ) async* {
    final root = await getApplicationCacheDirectory();
    final cacheDir = Directory(p.join(root.path, 'map_tiles'));

    // Determine all tiles needed
    final List<_TileToDownload> tiles = [];
    final crs = const Epsg3857();

    for (int z = minZoom; z <= maxZoom; z++) {
      final nwPoint = crs.latLngToPoint(bounds.northWest, z.toDouble());
      final sePoint = crs.latLngToPoint(bounds.southEast, z.toDouble());

      final tileSize = 256.0;

      final minX = (nwPoint.x / tileSize).floor();
      final maxX = (sePoint.x / tileSize).floor();
      final minY = (nwPoint.y / tileSize).floor();
      final maxY = (sePoint.y / tileSize).floor();

      for (int x = minX; x <= maxX; x++) {
        for (int y = minY; y <= maxY; y++) {
          tiles.add(_TileToDownload(z: z, x: x, y: y));
        }
      }
    }

    final total = tiles.length;
    if (total == 0) {
      yield 1.0;
      return;
    }

    int completed = 0;
    yield 0.0;

    // Download in chunks to avoid overwhelming the server/sockets
    const chunkSize = 10;
    for (int i = 0; i < total; i += chunkSize) {
      final chunk = tiles.skip(i).take(chunkSize);

      await Future.wait(
        chunk.map((tile) async {
          final tilePath = p.join(
            cacheDir.path,
            '\${tile.z}',
            '\${tile.x}',
            '\${tile.y}.png',
          );
          final file = File(tilePath);

          if (!await file.exists()) {
            try {
              final url = _urlTemplate
                  .replaceAll('{z}', '\${tile.z}')
                  .replaceAll('{x}', '\${tile.x}')
                  .replaceAll('{y}', '\${tile.y}');

              final request = await _httpClient.getUrl(Uri.parse(url));
              request.headers.set(
                'User-Agent',
                'Smart_GPS_Fields_Area_Measure/1.0.0',
              );
              final response = await request.close();

              if (response.statusCode == 200) {
                await file.parent.create(recursive: true);
                await response.pipe(file.openWrite());
              } else {
                // Drain response body to prevent socket leaks
                await response.drain();
              }
            } catch (e) {
              // Ignore individual tile failures
            }
          }
          completed++;
        }),
      );

      yield completed / total;
    }
  }

  @override
  Future<void> clearCache() async {
    final root = await getApplicationCacheDirectory();
    final cacheDir = Directory(p.join(root.path, 'map_tiles'));
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }

  @override
  Future<int> getCacheSize() async {
    final root = await getApplicationCacheDirectory();
    final cacheDir = Directory(p.join(root.path, 'map_tiles'));
    if (!await cacheDir.exists()) return 0;

    int totalSize = 0;
    await for (final entity in cacheDir.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }
}

class _TileToDownload {
  const _TileToDownload({required this.z, required this.x, required this.y});
  final int z;
  final int x;
  final int y;
}
