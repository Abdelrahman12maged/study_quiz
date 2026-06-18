import 'package:flutter/material.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/theme/color_schemes.dart';
import 'package:study_quiz/core/widgets/app_card.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

class ReviewItem extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final int? userAnswerIndex;
  final bool isCorrect;

  const ReviewItem({
    super.key,
    required this.question,
    required this.questionNumber,
    this.userAnswerIndex,
    required this.isCorrect,
  });

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sem = AppSemanticColors.of(context);
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: widget.isCorrect ? sem.success : sem.error,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.questionNumberAndText(widget.questionNumber, widget.question.text),
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Icon(
                _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            // Show correct answer
            Row(
              children: [
                Icon(Icons.check_rounded, size: 14, color: sem.success),
                const SizedBox(width: AppSpacing.xs),
                Text(l10n.correctAnswer,
                    style: tt.labelSmall?.copyWith(color: sem.success)),
                Expanded(
                  child: Text(
                    widget.question.options[widget.question.correctIndex],
                    style: tt.bodySmall?.copyWith(color: sem.onSuccessContainer),
                  ),
                ),
              ],
            ),
            // Show user's answer if wrong
            if (!widget.isCorrect && widget.userAnswerIndex != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.close_rounded, size: 14, color: sem.error),
                  const SizedBox(width: AppSpacing.xs),
                  Text(l10n.yourAnswer,
                      style: tt.labelSmall?.copyWith(color: sem.error)),
                  Expanded(
                    child: Text(
                      widget.question.options[widget.userAnswerIndex!],
                      style: tt.bodySmall?.copyWith(color: sem.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(widget.question.explanation,
                style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant, height: 1.5)),
          ],
        ],
      ),
    );
  }
}
