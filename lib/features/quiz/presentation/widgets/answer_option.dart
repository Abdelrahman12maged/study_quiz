import 'package:flutter/material.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/theme/color_schemes.dart';
import 'package:study_quiz/features/quiz/presentation/cubit/quiz_state.dart';

class AnswerOption extends StatelessWidget {
  final String label;
  final int index;
  final QuizActive state;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.label,
    required this.index,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantics = AppSemanticColors.of(context);
    final tt = Theme.of(context).textTheme;

    final isSelected = state.lastSelectedIndex == index;
    final isCorrect = state.currentQuestion.correctIndex == index;
    final hasAnswered = state.hasAnswered;

    Color bgColor;
    Color borderColor;
    Color textColor;
    Widget? trailingIcon;

    if (!hasAnswered) {
      if (isSelected) {
        bgColor = cs.primaryContainer;
        borderColor = cs.primary;
        textColor = cs.onPrimaryContainer;
      } else {
        bgColor = cs.surfaceContainerLow;
        borderColor = cs.outlineVariant;
        textColor = cs.onSurface;
      }
      trailingIcon = null;
    } else {
      if (isCorrect) {
        bgColor = semantics.successContainer;
        borderColor = semantics.success;
        textColor = semantics.onSuccessContainer;
        trailingIcon = Icon(Icons.check_circle_rounded,
            color: semantics.success, size: 20);
      } else if (isSelected && !isCorrect) {
        bgColor = semantics.errorContainer;
        borderColor = semantics.error;
        textColor = semantics.onErrorContainer;
        trailingIcon = Icon(Icons.cancel_rounded,
            color: semantics.error, size: 20);
      } else {
        bgColor = cs.surfaceContainerLow;
        borderColor = cs.outlineVariant.withValues(alpha: 0.5);
        textColor = cs.onSurface.withValues(alpha: 0.5);
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                // Option letter badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: tt.labelMedium?.copyWith(
                          color: borderColor, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(label,
                      style: tt.bodyMedium?.copyWith(color: textColor)),
                ),
                if (trailingIcon != null) trailingIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
