import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

class ExplanationCard extends StatelessWidget {
  final Question question;
  const ExplanationCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (_, opacity, child) => Opacity(opacity: opacity, child: child),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 16, color: cs.tertiary),
                const SizedBox(width: AppSpacing.xs),
                Text(l10n.explanation,
                    style: tt.labelMedium?.copyWith(
                        color: cs.tertiary, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(question.explanation,
                style: tt.bodyMedium?.copyWith(height: 1.6)),

            // Source link
            if (question.sourceUrl != null) ...[
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.tryParse(question.sourceUrl!);
                  if (uri != null) await launchUrl(uri);
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.link_rounded, size: 16, color: cs.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          question.sourceTitle ?? question.sourceUrl!,
                          style: tt.labelSmall?.copyWith(
                              color: cs.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: cs.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.open_in_new_rounded,
                          size: 14, color: cs.primary),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
