import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/cache/preference_store.dart';
import '../../core/colors.dart';
import '../../core/enum.dart';

@singleton
class ThemeService {
  ThemeService(this._preferenceStore);

  final PreferenceStore _preferenceStore;

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  void getThemeMode() {
    final bool isLight =
        _preferenceStore.getValue(SharedPreferenceStore.IS_DARK_THEME) ?? true;
    themeNotifier.value = isLight ? ThemeMode.light : ThemeMode.dark;
    AppColors.isLightTheme = isLight;
  }

  void changeTheme() {
    final isDark = themeNotifier.value == ThemeMode.dark;
    themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
    _preferenceStore.setValue(SharedPreferenceStore.IS_DARK_THEME, isDark);
    AppColors.isLightTheme = !isDark;
  }
}
