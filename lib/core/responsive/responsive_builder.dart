import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// A LayoutBuilder wrapper that dispatches to [mobile], [tablet], or [desktop]
/// callbacks based on the available width.
///
/// Usage:
/// ```dart
/// ResponsiveBuilder(
///   mobile: (context, constraints) => MobileHome(),
///   tablet: (context, constraints) => TabletHome(),
/// )
/// ```
///
/// If [desktop] is not provided, it falls back to [tablet].
/// If [tablet] is not provided, it falls back to [mobile].
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)? tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (Breakpoints.isDesktop(width)) {
          return (desktop ?? tablet ?? mobile)(context, constraints);
        }
        if (Breakpoints.isTablet(width)) {
          return (tablet ?? mobile)(context, constraints);
        }
        return mobile(context, constraints);
      },
    );
  }
}

/// Static helpers that use MediaQuery — useful in places where
/// LayoutBuilder constraints aren't available (e.g., deciding
/// navigation type in the app shell).
class ResponsiveUtils {
  ResponsiveUtils._();

  static DeviceType deviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (Breakpoints.isDesktop(width)) return DeviceType.desktop;
    if (Breakpoints.isTablet(width)) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      deviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      deviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      deviceType(context) == DeviceType.desktop;
}
