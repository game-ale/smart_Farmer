import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_gps_area/core/constants/app_constants.dart';
import 'package:smart_gps_area/core/router/app_router.dart';
import 'package:smart_gps_area/core/theme/app_theme.dart';
import 'package:smart_gps_area/injection/injection_container.dart';

class SmartGpsAreaApp extends StatelessWidget {
  const SmartGpsAreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('om'), Locale('am')],
    );
  }
}
