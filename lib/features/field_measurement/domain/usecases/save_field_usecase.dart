import 'package:flutter/foundation.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';

class SaveFieldUseCase {
  const SaveFieldUseCase();

  Future<void> call(FieldEntity field) async {
    // Mock save operation for Phase 6
    // In Phase 7, this will be wired to a FieldRepository for Hive persistence
    debugPrint('Mock Saving Field: ${field.name} (${field.areaSqMeters} m²)');
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
