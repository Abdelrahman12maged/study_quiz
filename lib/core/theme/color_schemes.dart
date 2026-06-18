import 'package:flutter/material.dart';

/// Custom color schemes for AI Study Buddy.
///
/// Primary: Deep indigo (#3B4FD8) — focused, calm, academic.
/// Secondary: Warm teal (#2BA89E) — complementary, fresh.
/// Tertiary: Amber coral (#F5A623) — accent for highlights and CTAs.
/// Semantic: Green for correct, soft red for incorrect, amber for warnings.
class AppColorSchemes {
  AppColorSchemes._();

  // ─── Seed colors ───────────────────────────────────────────
  static const Color _primarySeed = Color(0xFF3B4FD8);
  static const Color _secondarySeed = Color(0xFF2BA89E);
  static const Color _tertiarySeed = Color(0xFFF5A623);

  // ─── Light scheme ──────────────────────────────────────────
  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: _primarySeed,
    brightness: Brightness.light,
    secondary: _secondarySeed,
    tertiary: _tertiarySeed,
  ).copyWith(
    // Override surface variants for more contrast
    surfaceContainerLowest: const Color(0xFFF8F9FD),
    surfaceContainerLow: const Color(0xFFF1F3FA),
    surfaceContainer: const Color(0xFFEBEDF7),
    surfaceContainerHigh: const Color(0xFFE3E6F3),
  );

  // ─── Dark scheme ───────────────────────────────────────────
  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: _primarySeed,
    brightness: Brightness.dark,
    secondary: _secondarySeed,
    tertiary: _tertiarySeed,
  ).copyWith(
    surfaceContainerLowest: const Color(0xFF0F1118),
    surfaceContainerLow: const Color(0xFF15171F),
    surfaceContainer: const Color(0xFF1A1D27),
    surfaceContainerHigh: const Color(0xFF22252F),
  );
}

/// Semantic colors used app-wide for quiz feedback, status chips, etc.
/// Access via `AppSemanticColors.of(context)` — picks light or dark automatically.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color error;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;

  const AppSemanticColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.error,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  static const AppSemanticColors light = AppSemanticColors(
    success: Color(0xFF2E7D50),
    successContainer: Color(0xFFD4F5E0),
    onSuccessContainer: Color(0xFF1B4D30),
    error: Color(0xFFCC3D3D),
    errorContainer: Color(0xFFFDE8E8),
    onErrorContainer: Color(0xFF7A2424),
    warning: Color(0xFFE6A817),
    warningContainer: Color(0xFFFFF4D6),
    onWarningContainer: Color(0xFF8A6600),
    info: Color(0xFF3B4FD8),
    infoContainer: Color(0xFFE0E4F9),
    onInfoContainer: Color(0xFF242F82),
  );

  static const AppSemanticColors darkScheme = AppSemanticColors(
    success: Color(0xFF6FCF97),
    successContainer: Color(0xFF1A3A28),
    onSuccessContainer: Color(0xFFC8F0D8),
    error: Color(0xFFEF8A8A),
    errorContainer: Color(0xFF3A1A1A),
    onErrorContainer: Color(0xFFF5CCCC),
    warning: Color(0xFFF5D06B),
    warningContainer: Color(0xFF3A2E0A),
    onWarningContainer: Color(0xFFFAE8B5),
    info: Color(0xFF8B9CF5),
    infoContainer: Color(0xFF1E2450),
    onInfoContainer: Color(0xFFCCD2FA),
  );

  /// Convenience accessor from BuildContext
  static AppSemanticColors of(BuildContext context) {
    return Theme.of(context).extension<AppSemanticColors>()!;
  }

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? error,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }
}
