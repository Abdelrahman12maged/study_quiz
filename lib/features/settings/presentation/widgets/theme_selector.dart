import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/settings/presentation/cubit/settings_cubit.dart';

class ThemeSelector extends StatelessWidget {
  final ThemeMode current;
  const ThemeSelector({super.key, required this.current});

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
            const Icon(Icons.palette_outlined),
            const SizedBox(width: AppSpacing.md),
            Text(l10n.theme, style: Theme.of(context).textTheme.titleSmall),
          ]),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: ThemeMode.values.map((mode) {
              final isSelected = current == mode;
              final label = switch (mode) {
                ThemeMode.system => l10n.themeSystem,
                ThemeMode.light => l10n.themeLight,
                ThemeMode.dark => l10n.themeDark,
              };
              final icon = switch (mode) {
                ThemeMode.system => Icons.brightness_auto_rounded,
                ThemeMode.light => Icons.light_mode_rounded,
                ThemeMode.dark => Icons.dark_mode_rounded,
              };
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () =>
                        context.read<SettingsCubit>().setThemeMode(mode),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primaryContainer
                            : cs.surfaceContainerHigh,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color: isSelected
                              ? cs.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(icon,
                              color: isSelected
                                  ? cs.primary
                                  : cs.onSurfaceVariant,
                              size: 20),
                          const SizedBox(height: 4),
                          Text(label,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? cs.primary
                                        : cs.onSurfaceVariant,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
