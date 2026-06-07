import 'package:flutter_map/flutter_map.dart';
import 'package:smart_gps_area/features/map_view/domain/repositories/map_repository.dart';

class DownloadMapAreaUseCase {
  const DownloadMapAreaUseCase(this._repository);

  final MapRepository _repository;

  Stream<double> call(LatLngBounds bounds, int minZoom, int maxZoom) {
    return _repository.downloadTiles(bounds, minZoom, maxZoom);
  }
}
