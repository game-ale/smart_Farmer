import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_gps_area/features/field_history/domain/usecases/field_usecases.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';

part 'field_history_event.dart';
part 'field_history_state.dart';

class FieldHistoryBloc extends Bloc<FieldHistoryEvent, FieldHistoryState> {
  FieldHistoryBloc({
    required this.getAllFields,
    required this.deleteField,
    required this.searchFields,
  }) : super(const FieldHistoryState()) {
    on<FieldHistoryLoaded>(_onLoaded);
    on<FieldHistorySearchChanged>(_onSearchChanged);
    on<FieldHistoryDeleteRequested>(_onDeleteRequested);
  }

  final GetAllFieldsUseCase getAllFields;
  final DeleteFieldUseCase deleteField;
  final SearchFieldsUseCase searchFields;

  Future<void> _onLoaded(
    FieldHistoryLoaded event,
    Emitter<FieldHistoryState> emit,
  ) async {
    emit(state.copyWith(status: FieldHistoryStatus.loading));
    try {
      final fields = await getAllFields();
      emit(state.copyWith(status: FieldHistoryStatus.loaded, fields: fields));
    } catch (e) {
      emit(
        state.copyWith(
          status: FieldHistoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchChanged(
    FieldHistorySearchChanged event,
    Emitter<FieldHistoryState> emit,
  ) async {
    try {
      final fields = await searchFields(event.query);
      emit(state.copyWith(fields: fields, searchQuery: event.query));
    } catch (e) {
      emit(
        state.copyWith(
          status: FieldHistoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    FieldHistoryDeleteRequested event,
    Emitter<FieldHistoryState> emit,
  ) async {
    try {
      await deleteField(event.fieldId);
      // Reload the list
      final fields = state.searchQuery.isEmpty
          ? await getAllFields()
          : await searchFields(state.searchQuery);
      emit(state.copyWith(fields: fields));
    } catch (e) {
      emit(
        state.copyWith(
          status: FieldHistoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
