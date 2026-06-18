import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_quiz/core/constants/app_constants.dart';
import 'settings_state.dart';

/// Manages app-level settings: theme mode and locale.
/// Persists to SharedPreferences so choices survive restarts.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(AppConstants.keyThemeMode) ?? 0;
    final locale = prefs.getString(AppConstants.keyLocale) ?? 'en';

    emit(SettingsState(
      themeMode: ThemeMode.values[themeModeIndex],
      locale: locale,
    ));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyThemeMode, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLocale, locale);
    emit(state.copyWith(locale: locale));
  }
}
