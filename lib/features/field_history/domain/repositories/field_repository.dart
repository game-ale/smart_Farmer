import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';

abstract interface class FieldRepository {
  Future<void> saveField(FieldEntity field);
  Future<List<FieldEntity>> getAllFields();
  Future<FieldEntity?> getFieldById(String id);
  Future<void> deleteField(String id);
  Future<List<FieldEntity>> searchFields(String query);
}
