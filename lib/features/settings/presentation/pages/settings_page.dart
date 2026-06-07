import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_event.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_state.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildSectionHeader(context, l10n.general),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              subtitle: Text(_languageLabel(l10n, state.settings.language)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(RouteConstants.language),
            ),
            const Divider(),
            _buildSectionHeader(context, l10n.measurementSettings),
            ListTile(
              leading: const Icon(Icons.straighten),
              title: Text(l10n.defaultUnit),
              subtitle: Text(l10n.defaultUnitSubtitle),
              trailing: DropdownButton<AreaUnit>(
                value: state.settings.defaultAreaUnit,
                underline: const SizedBox(),
                items: AreaUnit.values.map((unit) {
                  return DropdownMenuItem<AreaUnit>(
                    value: unit,
                    child: Text(_unitLabel(l10n, unit)),
                  );
                }).toList(),
                onChanged: (unit) {
                  if (unit != null) {
                    context.read<SettingsBloc>().add(
                      SettingsDefaultUnitChanged(unit),
                    );
                  }
                },
              ),
            ),
            const Divider(),
            _buildSectionHeader(context, l10n.appearance),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text(l10n.themeMode),
              subtitle: Text(l10n.themeSubtitle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: const Icon(Icons.brightness_auto),
                    label: Text(l10n.themeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: const Icon(Icons.light_mode),
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: const Icon(Icons.dark_mode),
                    label: Text(l10n.themeDark),
                  ),
                ],
                selected: {state.settings.themeMode},
                onSelectionChanged: (selection) {
                  context.read<SettingsBloc>().add(
                    SettingsThemeModeChanged(selection.first),
                  );
                },
              ),
            ),
            const Divider(),
            _buildSectionHeader(context, l10n.about),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(l10n.version),
              subtitle: const Text('1.0.0+1'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, SupportedLanguage language) =>
      switch (language) {
        SupportedLanguage.english => l10n.english,
        SupportedLanguage.afanOromo => l10n.afanOromo,
        SupportedLanguage.amharic => l10n.amharic,
      };

  String _unitLabel(AppLocalizations l10n, AreaUnit unit) => switch (unit) {
    AreaUnit.squareMeters => l10n.unitSquareMeters,
    AreaUnit.hectares => l10n.unitHectares,
    AreaUnit.acres => l10n.unitAcres,
    AreaUnit.timad => l10n.unitTimad,
    AreaUnit.kert => l10n.unitKert,
  };
}
