import 'package:smart_gps_area/features/field_history/domain/repositories/field_repository.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';

class GetAllFieldsUseCase {
  const GetAllFieldsUseCase(this._repository);
  final FieldRepository _repository;

  Future<List<FieldEntity>> call() => _repository.getAllFields();
}

class GetFieldByIdUseCase {
  const GetFieldByIdUseCase(this._repository);
  final FieldRepository _repository;

  Future<FieldEntity?> call(String id) => _repository.getFieldById(id);
}

class DeleteFieldUseCase {
  const DeleteFieldUseCase(this._repository);
  final FieldRepository _repository;

  Future<void> call(String id) => _repository.deleteField(id);
}

class SearchFieldsUseCase {
  const SearchFieldsUseCase(this._repository);
  final FieldRepository _repository;

  Future<List<FieldEntity>> call(String query) =>
      _repository.searchFields(query);
}
