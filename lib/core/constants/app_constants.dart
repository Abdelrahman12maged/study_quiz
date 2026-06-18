/// App-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'AI Study Buddy';
  static const String appVersion = '1.0.0';

  // SharedPreferences keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);

  // Processing stage labels (for simulated pipeline)
  static const List<String> processingStages = [
    'Reading your notes…',
    'Extracting key concepts…',
    'Generating questions…',
    'Finding reference sources…',
    'Almost ready…',
  ];
}
