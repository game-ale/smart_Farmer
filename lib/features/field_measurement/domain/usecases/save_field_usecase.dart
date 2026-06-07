import 'package:smart_gps_area/features/field_history/domain/repositories/field_repository.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';

class SaveFieldUseCase {
  const SaveFieldUseCase(this._repository);

  final FieldRepository _repository;

  Future<void> call(FieldEntity field) async {
    await _repository.saveField(field);
  }
}
