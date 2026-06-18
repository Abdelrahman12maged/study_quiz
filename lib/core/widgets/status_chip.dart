import 'package:flutter/material.dart';
import 'package:study_quiz/core/theme/color_schemes.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';

enum SessionStatus { processing, ready, failed, pending }

/// A themed chip that maps [SessionStatus] → color + label.
class StatusChip extends StatelessWidget {
  final SessionStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final semantics = AppSemanticColors.of(context);
    final tt = Theme.of(context).textTheme;

    final (label, bg, fg, icon) = switch (status) {
      SessionStatus.ready => (
          'Ready',
          semantics.successContainer,
          semantics.onSuccessContainer,
          Icons.check_circle_rounded,
        ),
      SessionStatus.processing => (
          'Processing',
          semantics.warningContainer,
          semantics.onWarningContainer,
          Icons.hourglass_top_rounded,
        ),
      SessionStatus.failed => (
          'Failed',
          semantics.errorContainer,
          semantics.onErrorContainer,
          Icons.error_rounded,
        ),
      SessionStatus.pending => (
          'Pending',
          Theme.of(context).colorScheme.surfaceContainerHigh,
          Theme.of(context).colorScheme.onSurfaceVariant,
          Icons.schedule_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs + 1,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: tt.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
