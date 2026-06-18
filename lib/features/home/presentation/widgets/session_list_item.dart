import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/app_card.dart';
import 'package:study_quiz/core/widgets/status_chip.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

/// Single session list item.
class SessionListItem extends StatelessWidget {
  final QuizSession session;
  const SessionListItem({super.key, required this.session});

  SessionStatus get _chipStatus => switch (session.status) {
        QuizSessionStatus.ready => SessionStatus.ready,
        QuizSessionStatus.processing => SessionStatus.processing,
        QuizSessionStatus.failed => SessionStatus.failed,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final dateStr = DateFormat.MMMd().add_jm().format(session.createdAt);

    return AppCard(
      onTap: () {
        if (session.status == QuizSessionStatus.ready) {
          context.go('/quiz/${session.id}');
        }
      },
      child: Row(
        children: [
          // Subject icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(Icons.description_rounded,
                color: cs.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.subject,
                    style: tt.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(dateStr,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Status
          StatusChip(status: _chipStatus),
        ],
      ),
    );
  }
}
