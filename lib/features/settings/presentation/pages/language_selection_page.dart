import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_gps_area/features/settings/domain/entities/app_settings.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_event.dart';
import 'package:smart_gps_area/features/settings/presentation/bloc/settings_state.dart';
import 'package:smart_gps_area/l10n/app_localizations.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguageTitle)),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.selectLanguageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            for (final language in SupportedLanguage.values) ...[
              _LanguageCard(
                language: language,
                selected: language == state.settings.language,
                onTap: () => context.read<SettingsBloc>().add(
                  SettingsLanguageChanged(language),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final SupportedLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: selected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(language.flag, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.nativeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      language.englishName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Semantics(
                  label: l10n.selected,
                  child: Icon(Icons.check_circle, color: colorScheme.primary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
