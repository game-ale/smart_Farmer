import 'package:smart_gps_area/core/gis/coordinate.dart';
import 'package:smart_gps_area/features/field_history/data/datasources/local/field_local_data_source.dart';
import 'package:smart_gps_area/features/field_history/data/models/coordinate_model.dart';
import 'package:smart_gps_area/features/field_history/data/models/field_model.dart';
import 'package:smart_gps_area/features/field_history/domain/repositories/field_repository.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';

class FieldRepositoryImpl implements FieldRepository {
  const FieldRepositoryImpl(this._dataSource);

  final FieldLocalDataSource _dataSource;

  @override
  Future<void> saveField(FieldEntity field) async {
    final model = FieldModel(
      id: field.id,
      name: field.name,
      areaSqMeters: field.areaSqMeters,
      perimeterMeters: field.perimeterMeters,
      points: field.points
          .map(
            (c) => CoordinateModel(
              latitude: c.latitude,
              longitude: c.longitude,
              altitude: c.altitude,
              accuracy: c.accuracy,
            ),
          )
          .toList(),
      createdAt: field.createdAt,
    );
    await _dataSource.saveField(model);
  }

  @override
  Future<List<FieldEntity>> getAllFields() async {
    final models = await _dataSource.getAllFields();
    return models.map(_toEntity).toList();
  }

  @override
  Future<FieldEntity?> getFieldById(String id) async {
    final model = await _dataSource.getFieldById(id);
    if (model == null) return null;
    return _toEntity(model);
  }

  @override
  Future<void> deleteField(String id) async {
    await _dataSource.softDeleteField(id);
  }

  @override
  Future<List<FieldEntity>> searchFields(String query) async {
    final models = await _dataSource.searchFields(query);
    return models.map(_toEntity).toList();
  }

  FieldEntity _toEntity(FieldModel model) {
    return FieldEntity(
      id: model.id,
      name: model.name,
      areaSqMeters: model.areaSqMeters,
      perimeterMeters: model.perimeterMeters,
      points: model.points
          .map(
            (c) => Coordinate(
              latitude: c.latitude,
              longitude: c.longitude,
              altitude: c.altitude,
              accuracy: c.accuracy,
            ),
          )
          .toList(),
      createdAt: model.createdAt,
    );
  }
}
