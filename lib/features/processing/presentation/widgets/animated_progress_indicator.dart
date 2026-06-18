import 'package:flutter/material.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/processing/presentation/cubit/processing_state.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  final ProcessingInProgress state;
  final String localizedStageLabel;

  const AnimatedProgressIndicator({
    super.key,
    required this.state,
    required this.localizedStageLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Animated icon
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (_, value, child) => Transform.scale(
            scale: 0.8 + 0.2 * value,
            child: Opacity(opacity: value, child: child),
          ),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 48),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Stage label with animated swap
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            localizedStageLabel,
            key: ValueKey(state.stageIndex),
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Progress bar
        SizedBox(
          width: 240,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: state.progress),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  builder: (_, value, __) => LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: cs.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation(cs.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.stepOfTotal(state.stageIndex + 1, state.totalStages),
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
