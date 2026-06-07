part of 'field_history_bloc.dart';

enum FieldHistoryStatus { initial, loading, loaded, error }

class FieldHistoryState extends Equatable {
  const FieldHistoryState({
    this.status = FieldHistoryStatus.initial,
    this.fields = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  final FieldHistoryStatus status;
  final List<FieldEntity> fields;
  final String searchQuery;
  final String? errorMessage;

  FieldHistoryState copyWith({
    FieldHistoryStatus? status,
    List<FieldEntity>? fields,
    String? searchQuery,
    String? errorMessage,
  }) {
    return FieldHistoryState(
      status: status ?? this.status,
      fields: fields ?? this.fields,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, fields, searchQuery, errorMessage];
}
