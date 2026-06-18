import 'package:flutter/material.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';

/// A theme-aware primary button with idle, loading, and disabled states.
///
/// Set [isExpanded] to true to fill available width.
/// Set [isLoading] to true to show an inline spinner.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final ButtonStyle? style;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: cs.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label, style: tt.labelLarge?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.w600)),
            ],
          );

    final btn = ElevatedButton(
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      style: style,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: child,
      ),
    );

    return isExpanded ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

/// Secondary outlined button variant.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(label),
      ],
    );

    final btn = OutlinedButton(onPressed: onPressed, child: child);
    return isExpanded ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}
