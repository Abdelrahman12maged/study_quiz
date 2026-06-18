import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/history/presentation/cubit/history_cubit.dart';
import 'package:study_quiz/features/history/presentation/cubit/history_state.dart';

class HistoryHeader extends StatelessWidget {
  final HistoryLoaded state;
  const HistoryHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final subjects = [l10n.all, ...state.availableSubjects];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.history, style: tt.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.xs),
            itemBuilder: (_, i) {
              final sub = subjects[i];
              final isAll = sub == l10n.all;
              // Map display subject to actual subject (since 'All' isn't in availableSubjects)
              final filterValue = isAll ? null : sub;

              final selected = isAll
                  ? state.filterSubject == null
                  : state.filterSubject == sub;
              return FilterChip(
                label: Text(sub, style: tt.labelSmall),
                selected: selected,
                onSelected: (_) {
                  context
                      .read<HistoryCubit>()
                      .filterBySubject(filterValue);
                },
                selectedColor: cs.primaryContainer,
                checkmarkColor: cs.primary,
                side: BorderSide.none,
              );
            },
          ),
        ),
      ],
    );
  }
}
