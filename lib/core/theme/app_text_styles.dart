import 'package:flutter/material.dart';

/// Convenience extension on BuildContext for quick text style access.
///
/// Usage: `context.textStyles.heading` instead of
/// `Theme.of(context).textTheme.headlineMedium`
extension AppTextStylesExtension on BuildContext {
  AppTextStyles get textStyles => AppTextStyles(this);
}

class AppTextStyles {
  final BuildContext _context;
  const AppTextStyles(this._context);

  TextTheme get _theme => Theme.of(_context).textTheme;

  TextStyle? get displayLarge => _theme.displayLarge;
  TextStyle? get displayMedium => _theme.displayMedium;
  TextStyle? get displaySmall => _theme.displaySmall;
  TextStyle? get heading => _theme.headlineMedium;
  TextStyle? get headingSmall => _theme.headlineSmall;
  TextStyle? get title => _theme.titleLarge;
  TextStyle? get titleMedium => _theme.titleMedium;
  TextStyle? get titleSmall => _theme.titleSmall;
  TextStyle? get body => _theme.bodyLarge;
  TextStyle? get bodyMedium => _theme.bodyMedium;
  TextStyle? get bodySmall => _theme.bodySmall;
  TextStyle? get label => _theme.labelLarge;
  TextStyle? get labelMedium => _theme.labelMedium;
  TextStyle? get labelSmall => _theme.labelSmall;
}
