import 'package:flutter/material.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/home/presentation/cubit/home_state.dart';
import 'package:study_quiz/features/home/presentation/widgets/stat_card.dart';

/// Stats summary row with 3 stat cards.
class StatsRow extends StatelessWidget {
  final HomeLoaded state;
  const StatsRow({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.quiz_rounded,
            label: l10n.thisWeek,
            value: '${state.questionsThisWeek}',
            subtitle: l10n.questionsLabel,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: StatCard(
            icon: Icons.trending_up_rounded,
            label: l10n.accuracy,
            value: '${(state.weeklyAccuracy * 100).round()}%',
            subtitle: l10n.correctLabel,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: StatCard(
            icon: Icons.local_fire_department_rounded,
            label: l10n.streak,
            value: '${state.streakDays}',
            subtitle: l10n.daysLabel,
          ),
        ),
      ],
    );
  }
}
