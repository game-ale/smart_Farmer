import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_gps_area/core/constants/app_constants.dart';
import 'package:smart_gps_area/core/localization/fallback_localizations_delegate.dart';
import 'package:smart_gps_area/core/router/app_router.dart';
import 'package:smart_gps_area/core/theme/app_theme.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_event.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_state.dart';
import 'package:smart_gps_area/injection/injection_container.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class SmartGpsAreaApp extends StatelessWidget {
  const SmartGpsAreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;

    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()
        ..add(
          SettingsStarted(
            deviceLocale: WidgetsBinding.instance.platformDispatcher.locale,
          ),
        ),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => MaterialApp.router(
          title: AppConstants.appName,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.settings.themeMode,
          locale: state.settings.language.locale,
          routerConfig: router,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            const FallbackMaterialLocalizationDelegate(),
            const FallbackCupertinoLocalizationDelegate(),
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
