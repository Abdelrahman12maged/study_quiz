import 'package:flutter/material.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

class QuestionTypeBadge extends StatelessWidget {
  final QuestionType type;
  const QuestionTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    
    final label = type == QuestionType.mcq 
        ? l10n.multipleChoice 
        : l10n.trueOrFalse;
    final icon = type == QuestionType.mcq
        ? Icons.checklist_rounded
        : Icons.toggle_on_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xxs + 1),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(label,
              style: tt.labelSmall?.copyWith(
                  color: cs.onSecondaryContainer, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
