// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart GPS Fields';

  @override
  String get homeShellMessage => 'Project architecture shell';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose app language';

  @override
  String get selectLanguageTitle => 'Select Language';

  @override
  String get selectLanguageSubtitle =>
      'Choose the language you want to use in the app.';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get themeMode => 'Theme';

  @override
  String get themeSubtitle => 'Appearance mode';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get english => 'English';

  @override
  String get afanOromo => 'Afan Oromo';

  @override
  String get amharic => 'Amharic';

  @override
  String get currentLanguage => 'Current language';

  @override
  String get selected => 'Selected';

  @override
  String get defaultUnit => 'Default unit';

  @override
  String get defaultUnitSubtitle => 'Area display unit';

  @override
  String get unitSquareMeters => 'Square Meters';

  @override
  String get unitHectares => 'Hectares';

  @override
  String get unitAcres => 'Acres';

  @override
  String get unitTimad => 'Timad';

  @override
  String get unitKert => 'Kert';

  @override
  String get unitShortSqm => 'm²';

  @override
  String get unitShortHa => 'ha';

  @override
  String get unitShortAcre => 'ac';

  @override
  String get unitShortTimad => 'timad';

  @override
  String get unitShortKert => 'kert';

  @override
  String get measure => 'Measure';

  @override
  String get myFields => 'My Fields';

  @override
  String get map => 'Map';

  @override
  String get settings => 'Settings';

  @override
  String get gpsMeasurement => 'GPS Measurement';

  @override
  String get manualMeasurement => 'Manual Measurement';

  @override
  String get results => 'Results';

  @override
  String get onboarding => 'Onboarding';

  @override
  String get fieldDetail => 'Field Detail';

  @override
  String get phaseComingSoon => 'Implemented in a later phase.';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'App version and info';

  @override
  String get version => 'Version';

  @override
  String get appDescription =>
      'Offline-first GPS field area measurement app for Ethiopian smallholder farmers.';

  @override
  String get general => 'General';

  @override
  String get appearance => 'Appearance';

  @override
  String get measurementSettings => 'Measurement';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'No data available';

  @override
  String get loading => 'Loading…';

  @override
  String get measurementMode => 'Measurement Mode';

  @override
  String get howToMeasure => 'How do you want to measure your field?';

  @override
  String get gpsMeasurementDesc =>
      'Physically walk the perimeter of your field. The app will use your location to automatically drop boundary points and calculate the exact area.';

  @override
  String get manualMeasurementDesc =>
      'Draw the field boundaries yourself by tapping directly on the map. Perfect if you already know your field shape on a satellite view.';

  @override
  String get area => 'Area';

  @override
  String get points => 'Points';

  @override
  String get perimeter => 'Perimeter';

  @override
  String get startWalking => 'START WALKING';

  @override
  String get pause => 'PAUSE';

  @override
  String get resume => 'RESUME';

  @override
  String get undo => 'UNDO';

  @override
  String get finish => 'FINISH';

  @override
  String get clearAll => 'CLEAR ALL';

  @override
  String get gpsSignalRestored => 'GPS Signal restored. Resumed.';

  @override
  String get poorGpsAccuracy => 'Poor GPS Accuracy. Measurement Auto-Paused.';

  @override
  String get gpsWaiting => 'Waiting';

  @override
  String get gpsGood => 'Good';

  @override
  String get gpsPoor => 'Poor';

  @override
  String get gpsLost => 'Lost';

  @override
  String get gpsNoPermission => 'No Permission';

  @override
  String get measurementComplete => 'Measurement Complete';

  @override
  String boundaryPointsRecorded(int count) {
    return '$count boundary points recorded';
  }

  @override
  String get measurementResults => 'Measurement Results';

  @override
  String get saveField => 'SAVE FIELD';

  @override
  String get discard => 'DISCARD';

  @override
  String get saveMeasurement => 'Save Measurement';

  @override
  String get fieldName => 'Field Name';

  @override
  String get fieldNameHint => 'e.g. North Farm Plot';

  @override
  String get fieldNameRequired => 'Please enter a field name';

  @override
  String fieldSavedSuccess(String name) {
    return 'Field \"$name\" saved successfully!';
  }

  @override
  String get noMeasurementData => 'No measurement data available.';

  @override
  String get searchFields => 'Search fields...';

  @override
  String get noFieldsYet =>
      'No saved fields yet.\nMeasure a field to get started!';

  @override
  String noFieldsMatching(String query) {
    return 'No fields matching \"$query\"';
  }

  @override
  String get deleteField => 'Delete Field?';

  @override
  String deleteFieldConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String fieldDeleted(String name) {
    return '\"$name\" deleted';
  }

  @override
  String get fieldNotFound => 'Field not found.';

  @override
  String measuredOn(String date) {
    return 'Measured on $date';
  }

  @override
  String get boundaryPoints => 'Boundary Points';

  @override
  String get tapMapInstruction =>
      'Tap anywhere on the map to add a boundary point. Tap a point to delete it.';

  @override
  String get waitingForGps => 'Waiting for GPS...';

  @override
  String get downloadOffline => 'Download visible area for offline use';

  @override
  String get downloadingMap => 'Downloading Map Area...';

  @override
  String get onboardingTitle1 => 'Map Your Fields Offline';

  @override
  String get onboardingDesc1 =>
      'Measure the exact area of your land without needing an internet connection.';

  @override
  String get onboardingTitle2 => 'Walk the Perimeter';

  @override
  String get onboardingDesc2 =>
      'Use GPS mode to physically walk around your field. The app will automatically drop boundary points and calculate the area.';

  @override
  String get onboardingTitle3 => 'Tap to Draw Boundaries';

  @override
  String get onboardingDesc3 =>
      'Use Manual mode to simply tap the corners of your field on the map to get instant area calculations.';

  @override
  String get skip => 'SKIP';

  @override
  String get next => 'NEXT';

  @override
  String get getStarted => 'GET STARTED';
}
