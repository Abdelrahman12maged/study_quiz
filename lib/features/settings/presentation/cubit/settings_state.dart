import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Settings state: theme mode and locale.
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final String locale; // 'en' or 'ar'

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = 'en',
  });

  SettingsState copyWith({ThemeMode? themeMode, String? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object> get props => [themeMode, locale];
}
