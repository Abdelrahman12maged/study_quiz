import 'package:flutter/material.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';

/// A consistently styled card used app-wide.
///
/// Pulls all styling from the theme — never hardcodes colors.
/// [onTap] makes the card tappable with an ink splash.
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool hasBorder;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd);

    return Material(
      color: backgroundColor ?? cs.surfaceContainerLow,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: hasBorder
              ? BoxDecoration(
                  borderRadius: radius,
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                )
              : null,
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
