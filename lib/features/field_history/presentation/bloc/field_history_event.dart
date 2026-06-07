part of 'field_history_bloc.dart';

sealed class FieldHistoryEvent extends Equatable {
  const FieldHistoryEvent();

  @override
  List<Object?> get props => [];
}

final class FieldHistoryLoaded extends FieldHistoryEvent {
  const FieldHistoryLoaded();
}

final class FieldHistorySearchChanged extends FieldHistoryEvent {
  const FieldHistorySearchChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

final class FieldHistoryDeleteRequested extends FieldHistoryEvent {
  const FieldHistoryDeleteRequested(this.fieldId);
  final String fieldId;

  @override
  List<Object?> get props => [fieldId];
}
