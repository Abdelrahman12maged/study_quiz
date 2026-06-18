import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Theme-aware shimmer skeleton loader.
///
/// Wrap any placeholder widget with [AppShimmer] to apply the shimmer effect.
/// Automatically adapts shimmer base/highlight colors to light/dark theme.
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? cs.surfaceContainerHigh
          : cs.surfaceContainerHigh.withValues(alpha: 0.8),
      highlightColor: isDark
          ? cs.surfaceContainerLow
          : cs.surface,
      child: child,
    );
  }
}

/// A shimmer placeholder box of given [width] and [height].
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}
