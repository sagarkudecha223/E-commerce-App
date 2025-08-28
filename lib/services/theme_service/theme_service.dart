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
    final bool isDarkTheme =
        _preferenceStore.getValue(SharedPreferenceStore.IS_DARK_THEME) ?? false;
    AppColors.isLightTheme = !isDarkTheme;
    themeNotifier.value = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    themeNotifier.value =
        themeNotifier.value == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;
    AppColors.isLightTheme = themeNotifier.value == ThemeMode.light;
    _preferenceStore.setValue(
      SharedPreferenceStore.IS_DARK_THEME,
      themeNotifier.value == ThemeMode.dark,
    );
  }
}
