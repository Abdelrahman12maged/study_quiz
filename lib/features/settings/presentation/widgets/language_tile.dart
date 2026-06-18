import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/settings/presentation/cubit/settings_cubit.dart';

class LanguageTile extends StatelessWidget {
  final String locale;
  const LanguageTile({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.language_rounded),
            const SizedBox(width: AppSpacing.md),
            Text(l10n.language, style: Theme.of(context).textTheme.titleSmall),
          ]),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'en', label: Text(l10n.english), icon: const Text('🇺🇸')),
              ButtonSegment(value: 'ar', label: Text(l10n.arabic), icon: const Text('🇸🇦')),
            ],
            selected: {locale},
            onSelectionChanged: (s) =>
                context.read<SettingsCubit>().setLocale(s.first),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return cs.primaryContainer;
                }
                return null;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
