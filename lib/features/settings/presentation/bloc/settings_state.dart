import 'package:equatable/equatable.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';

enum SettingsStatus { initial, loading, loaded, failure }

class SettingsState extends Equatable {
  const SettingsState({
    required this.status,
    required this.settings,
    this.errorMessage,
  });

  const SettingsState.initial()
    : status = SettingsStatus.initial,
      settings = const AppSettings.defaults(),
      errorMessage = null;

  final SettingsStatus status;
  final AppSettings settings;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    AppSettings? settings,
    String? errorMessage,
  }) => SettingsState(
    status: status ?? this.status,
    settings: settings ?? this.settings,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, settings, errorMessage];
}
