import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/app_card.dart';
import 'package:study_quiz/core/widgets/status_chip.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

class HistorySessionCard extends StatelessWidget {
  final QuizSession session;
  const HistorySessionCard({super.key, required this.session});

  SessionStatus get _chipStatus => switch (session.status) {
        QuizSessionStatus.ready => SessionStatus.ready,
        QuizSessionStatus.processing => SessionStatus.processing,
        QuizSessionStatus.failed => SessionStatus.failed,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final dateStr = DateFormat.yMMMd().format(session.createdAt);

    return AppCard(
      onTap: () {
        if (session.status == QuizSessionStatus.ready) {
          context.go('/quiz/${session.id}');
        }
      },
      child: Row(
        children: [
          // Thumbnail placeholder
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(Icons.article_rounded, color: cs.primary, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(session.subject,
                    style: tt.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(dateStr,
                    style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant)),
                if (session.questions.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(l10n.questionsCount(session.questions.length),
                      style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusChip(status: _chipStatus),
        ],
      ),
    );
  }
}
