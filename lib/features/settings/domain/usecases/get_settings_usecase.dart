import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';
import 'package:smart_gps_area/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  AppSettings call() => _repository.loadSettings();

  bool get hasSavedLanguage => _repository.hasSavedLanguage();
}
