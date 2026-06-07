import 'package:hive/hive.dart';
import 'package:smart_gps_area/core/storage/hive_box_names.dart';
import 'package:smart_gps_area/features/field_history/data/models/field_model.dart';

class FieldLocalDataSource {
  Box<FieldModel>? _box;

  Future<Box<FieldModel>> get box async {
    _box ??= await Hive.openBox<FieldModel>(HiveBoxNames.fields);
    return _box!;
  }

  Future<void> saveField(FieldModel field) async {
    final b = await box;
    await b.put(field.id, field);
  }

  Future<List<FieldModel>> getAllFields() async {
    final b = await box;
    return b.values.where((f) => !f.isDeleted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<FieldModel?> getFieldById(String id) async {
    final b = await box;
    final field = b.get(id);
    if (field != null && !field.isDeleted) return field;
    return null;
  }

  Future<void> softDeleteField(String id) async {
    final b = await box;
    final field = b.get(id);
    if (field != null) {
      field.isDeleted = true;
      await field.save();
    }
  }

  Future<void> hardDeleteField(String id) async {
    final b = await box;
    await b.delete(id);
  }

  Future<List<FieldModel>> searchFields(String query) async {
    final all = await getAllFields();
    if (query.isEmpty) return all;
    final lowerQuery = query.toLowerCase();
    return all.where((f) => f.name.toLowerCase().contains(lowerQuery)).toList();
  }
}
