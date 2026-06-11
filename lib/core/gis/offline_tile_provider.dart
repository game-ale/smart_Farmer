import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A custom TileProvider that fetches map tiles from the network and caches
/// them to the local file system (using path_provider) for offline use.
/// It also implements a simple background LRU cache eviction when exceeding 200MB.
class OfflineTileProvider extends TileProvider {
  OfflineTileProvider() {
    _initCacheDir();
  }

  Directory? _cacheDir;
  final HttpClient _httpClient = HttpClient();

  // 200 MB limit
  static const int maxCacheSizeBytes = 200 * 1024 * 1024;
  int _downloadCount = 0;

  Future<void> _initCacheDir() async {
    final root = await getApplicationCacheDirectory();
    _cacheDir = Directory(p.join(root.path, 'map_tiles'));
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
  }

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return _OfflineTileImageProvider(
      coordinates: coordinates,
      options: options,
      getCacheDir: () async {
        if (_cacheDir == null) await _initCacheDir();
        return _cacheDir!;
      },
      httpClient: _httpClient,
      onTileDownloaded: _onTileDownloaded,
    );
  }

  void _onTileDownloaded() {
    _downloadCount++;
    // Run cleanup every 100 new tile downloads to avoid constant IO checks
    if (_downloadCount >= 100) {
      _downloadCount = 0;
      _cleanupCache();
    }
  }

  Future<void> _cleanupCache() async {
    if (_cacheDir == null) return;
    try {
      final dir = _cacheDir!;
      if (!await dir.exists()) return;

      int totalSize = 0;
      final List<FileStatWithEntity> files = [];

      await for (final entity in dir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
          files.add(FileStatWithEntity(entity, stat));
        }
      }

      if (totalSize > maxCacheSizeBytes) {
        // Sort by last accessed time (oldest first)
        files.sort((a, b) => a.stat.accessed.compareTo(b.stat.accessed));

        // Delete until we are at 80% of max capacity (160MB)
        final targetSize = maxCacheSizeBytes * 0.8;
        for (final fileStat in files) {
          if (totalSize <= targetSize) break;
          await fileStat.file.delete();
          totalSize -= fileStat.stat.size;
        }
      }
    } catch (e) {
      // Ignore cleanup errors
      debugPrint('Error cleaning up tile cache: $e');
    }
  }
}

class FileStatWithEntity {
  const FileStatWithEntity(this.file, this.stat);
  final File file;
  final FileStat stat;
}

class _OfflineTileImageProvider
    extends ImageProvider<_OfflineTileImageProvider> {
  const _OfflineTileImageProvider({
    required this.coordinates,
    required this.options,
    required this.getCacheDir,
    required this.httpClient,
    required this.onTileDownloaded,
  });

  final TileCoordinates coordinates;
  final TileLayer options;
  final Future<Directory> Function() getCacheDir;
  final HttpClient httpClient;
  final VoidCallback onTileDownloaded;

  @override
  Future<_OfflineTileImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture<_OfflineTileImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _OfflineTileImageProvider key,
    ImageDecoderCallback decode,
  ) {
    final chunkEvents = StreamController<ImageChunkEvent>();
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: 1.0,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<TileCoordinates>('coordinates', coordinates),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    _OfflineTileImageProvider key,
    StreamController<ImageChunkEvent> chunkEvents,
    ImageDecoderCallback decode,
  ) async {
    try {
      final cacheDir = await getCacheDir();
      final z = coordinates.z;
      final x = coordinates.x;
      final y = coordinates.y;

      final tilePath = p.join(cacheDir.path, '$z', '$x', '$y.png');
      final file = File(tilePath);

      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
      }

      // Fallback url template
      final url = options.urlTemplate!
          .replaceAll('{z}', z.toString())
          .replaceAll('{x}', x.toString())
          .replaceAll('{y}', y.toString());

      final request = await httpClient.getUrl(Uri.parse(url));

      // Add standard user-agent for OSM
      request.headers.set('User-Agent', 'Smart_GPS_Fields_Area_Measure/1.0.0');

      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode} for tile $url');
      }

      final bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (cumulative, total) {
          chunkEvents.add(
            ImageChunkEvent(
              cumulativeBytesLoaded: cumulative,
              expectedTotalBytes: total,
            ),
          );
        },
      );

      // Save to cache
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      onTileDownloaded();

      return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    } catch (e) {
      // In case of error, rethrow to let Flutter map handle it
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _OfflineTileImageProvider &&
        other.coordinates == coordinates &&
        other.options.urlTemplate == options.urlTemplate;
  }

  @override
  int get hashCode => Object.hash(coordinates, options.urlTemplate);
}
