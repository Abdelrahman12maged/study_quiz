import 'package:flutter/material.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/processing/presentation/cubit/processing_state.dart';

class ProcessingStageChecklist extends StatelessWidget {
  final ProcessingInProgress state;
  final List<String> localizedStages;

  const ProcessingStageChecklist({
    super.key,
    required this.state,
    required this.localizedStages,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(state.totalStages, (i) {
        final isDone = i < state.stageIndex;
        final isCurrent = i == state.stageIndex;
        final isPending = i > state.stageIndex;
        final label = i < localizedStages.length 
            ? localizedStages[i] 
            : state.stageLabel; // Fallback to English

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDone
                    ? Icons.check_circle_rounded
                    : isCurrent
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                size: 20,
                color: isDone
                    ? cs.primary
                    : isCurrent
                        ? cs.tertiary
                        : cs.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: tt.bodyMedium?.copyWith(
                  color: isPending
                      ? cs.onSurfaceVariant.withValues(alpha: 0.5)
                      : cs.onSurface,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
