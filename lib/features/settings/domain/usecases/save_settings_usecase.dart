import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';
import 'package:smart_gps_area/features/settings/domain/repositories/settings_repository.dart';

class SaveSettingsUseCase {
  const SaveSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(AppSettings settings) => _repository.saveSettings(settings);
}
