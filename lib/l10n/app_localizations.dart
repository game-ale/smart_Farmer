import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';
import 'app_localizations_om.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
    Locale('om'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart GPS Fields'**
  String get appTitle;

  /// No description provided for @homeShellMessage.
  ///
  /// In en, this message translates to:
  /// **'Project architecture shell'**
  String get homeShellMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get languageSubtitle;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageTitle;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you want to use in the app.'**
  String get selectLanguageSubtitle;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance mode'**
  String get themeSubtitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @afanOromo.
  ///
  /// In en, this message translates to:
  /// **'Afan Oromo'**
  String get afanOromo;

  /// No description provided for @amharic.
  ///
  /// In en, this message translates to:
  /// **'Amharic'**
  String get amharic;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current language'**
  String get currentLanguage;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @defaultUnit.
  ///
  /// In en, this message translates to:
  /// **'Default unit'**
  String get defaultUnit;

  /// No description provided for @defaultUnitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Area display unit'**
  String get defaultUnitSubtitle;

  /// No description provided for @unitSquareMeters.
  ///
  /// In en, this message translates to:
  /// **'Square Meters'**
  String get unitSquareMeters;

  /// No description provided for @unitHectares.
  ///
  /// In en, this message translates to:
  /// **'Hectares'**
  String get unitHectares;

  /// No description provided for @unitAcres.
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get unitAcres;

  /// No description provided for @unitTimad.
  ///
  /// In en, this message translates to:
  /// **'Timad'**
  String get unitTimad;

  /// No description provided for @unitKert.
  ///
  /// In en, this message translates to:
  /// **'Kert'**
  String get unitKert;

  /// No description provided for @unitShortSqm.
  ///
  /// In en, this message translates to:
  /// **'m²'**
  String get unitShortSqm;

  /// No description provided for @unitShortHa.
  ///
  /// In en, this message translates to:
  /// **'ha'**
  String get unitShortHa;

  /// No description provided for @unitShortAcre.
  ///
  /// In en, this message translates to:
  /// **'ac'**
  String get unitShortAcre;

  /// No description provided for @unitShortTimad.
  ///
  /// In en, this message translates to:
  /// **'timad'**
  String get unitShortTimad;

  /// No description provided for @unitShortKert.
  ///
  /// In en, this message translates to:
  /// **'kert'**
  String get unitShortKert;

  /// No description provided for @measure.
  ///
  /// In en, this message translates to:
  /// **'Measure'**
  String get measure;

  /// No description provided for @myFields.
  ///
  /// In en, this message translates to:
  /// **'My Fields'**
  String get myFields;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @gpsMeasurement.
  ///
  /// In en, this message translates to:
  /// **'GPS Measurement'**
  String get gpsMeasurement;

  /// No description provided for @manualMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Manual Measurement'**
  String get manualMeasurement;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboarding;

  /// No description provided for @fieldDetail.
  ///
  /// In en, this message translates to:
  /// **'Field Detail'**
  String get fieldDetail;

  /// No description provided for @phaseComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Implemented in a later phase.'**
  String get phaseComingSoon;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App version and info'**
  String get aboutSubtitle;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Offline-first GPS field area measurement app for Ethiopian smallholder farmers.'**
  String get appDescription;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @measurementSettings.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurementSettings;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @measurementMode.
  ///
  /// In en, this message translates to:
  /// **'Measurement Mode'**
  String get measurementMode;

  /// No description provided for @howToMeasure.
  ///
  /// In en, this message translates to:
  /// **'How do you want to measure your field?'**
  String get howToMeasure;

  /// No description provided for @gpsMeasurementDesc.
  ///
  /// In en, this message translates to:
  /// **'Physically walk the perimeter of your field. The app will use your location to automatically drop boundary points and calculate the exact area.'**
  String get gpsMeasurementDesc;

  /// No description provided for @manualMeasurementDesc.
  ///
  /// In en, this message translates to:
  /// **'Draw the field boundaries yourself by tapping directly on the map. Perfect if you already know your field shape on a satellite view.'**
  String get manualMeasurementDesc;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @perimeter.
  ///
  /// In en, this message translates to:
  /// **'Perimeter'**
  String get perimeter;

  /// No description provided for @startWalking.
  ///
  /// In en, this message translates to:
  /// **'START WALKING'**
  String get startWalking;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resume;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'FINISH'**
  String get finish;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'CLEAR ALL'**
  String get clearAll;

  /// No description provided for @gpsSignalRestored.
  ///
  /// In en, this message translates to:
  /// **'GPS Signal restored. Resumed.'**
  String get gpsSignalRestored;

  /// No description provided for @poorGpsAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Poor GPS Accuracy. Measurement Auto-Paused.'**
  String get poorGpsAccuracy;

  /// No description provided for @gpsWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get gpsWaiting;

  /// No description provided for @gpsGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get gpsGood;

  /// No description provided for @gpsPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get gpsPoor;

  /// No description provided for @gpsLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get gpsLost;

  /// No description provided for @gpsNoPermission.
  ///
  /// In en, this message translates to:
  /// **'No Permission'**
  String get gpsNoPermission;

  /// No description provided for @measurementComplete.
  ///
  /// In en, this message translates to:
  /// **'Measurement Complete'**
  String get measurementComplete;

  /// No description provided for @boundaryPointsRecorded.
  ///
  /// In en, this message translates to:
  /// **'{count} boundary points recorded'**
  String boundaryPointsRecorded(int count);

  /// No description provided for @measurementResults.
  ///
  /// In en, this message translates to:
  /// **'Measurement Results'**
  String get measurementResults;

  /// No description provided for @saveField.
  ///
  /// In en, this message translates to:
  /// **'SAVE FIELD'**
  String get saveField;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'DISCARD'**
  String get discard;

  /// No description provided for @saveMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Save Measurement'**
  String get saveMeasurement;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get fieldName;

  /// No description provided for @fieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. North Farm Plot'**
  String get fieldNameHint;

  /// No description provided for @fieldNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a field name'**
  String get fieldNameRequired;

  /// No description provided for @fieldSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Field \"{name}\" saved successfully!'**
  String fieldSavedSuccess(String name);

  /// No description provided for @noMeasurementData.
  ///
  /// In en, this message translates to:
  /// **'No measurement data available.'**
  String get noMeasurementData;

  /// No description provided for @searchFields.
  ///
  /// In en, this message translates to:
  /// **'Search fields...'**
  String get searchFields;

  /// No description provided for @noFieldsYet.
  ///
  /// In en, this message translates to:
  /// **'No saved fields yet.\nMeasure a field to get started!'**
  String get noFieldsYet;

  /// No description provided for @noFieldsMatching.
  ///
  /// In en, this message translates to:
  /// **'No fields matching \"{query}\"'**
  String noFieldsMatching(String query);

  /// No description provided for @deleteField.
  ///
  /// In en, this message translates to:
  /// **'Delete Field?'**
  String get deleteField;

  /// No description provided for @deleteFieldConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteFieldConfirm(String name);

  /// No description provided for @fieldDeleted.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" deleted'**
  String fieldDeleted(String name);

  /// No description provided for @fieldNotFound.
  ///
  /// In en, this message translates to:
  /// **'Field not found.'**
  String get fieldNotFound;

  /// No description provided for @measuredOn.
  ///
  /// In en, this message translates to:
  /// **'Measured on {date}'**
  String measuredOn(String date);

  /// No description provided for @boundaryPoints.
  ///
  /// In en, this message translates to:
  /// **'Boundary Points'**
  String get boundaryPoints;

  /// No description provided for @tapMapInstruction.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on the map to add a boundary point. Tap a point to delete it.'**
  String get tapMapInstruction;

  /// No description provided for @waitingForGps.
  ///
  /// In en, this message translates to:
  /// **'Waiting for GPS...'**
  String get waitingForGps;

  /// No description provided for @downloadOffline.
  ///
  /// In en, this message translates to:
  /// **'Download visible area for offline use'**
  String get downloadOffline;

  /// No description provided for @downloadingMap.
  ///
  /// In en, this message translates to:
  /// **'Downloading Map Area...'**
  String get downloadingMap;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Map Your Fields Offline'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Measure the exact area of your land without needing an internet connection.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Walk the Perimeter'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Use GPS mode to physically walk around your field. The app will automatically drop boundary points and calculate the area.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Tap to Draw Boundaries'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Use Manual mode to simply tap the corners of your field on the map to get instant area calculations.'**
  String get onboardingDesc3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en', 'om'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
    case 'om':
      return AppLocalizationsOm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
