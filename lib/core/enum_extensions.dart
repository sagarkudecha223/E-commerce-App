import 'package:flutter/material.dart';

import 'colors.dart';
import 'enum.dart';

extension SharedPreferenceStoreExtractor on SharedPreferenceStore {
  String get preferenceKey => name;

  Type get getRuntimeType {
    switch (this) {
      case SharedPreferenceStore.IS_USER_LOGGED_IN:
        return bool;
      case SharedPreferenceStore.IS_DARK_THEME:
        return bool;
      case SharedPreferenceStore.USER_INFO:
        return String;
    }
  }
}

extension AppLoaderThemeColor on AppLoaderTheme {
  Color get backgroundColor {
    switch (this) {
      case AppLoaderTheme.light:
        return AppColors.primaryBlue1;
      case AppLoaderTheme.dark:
        return AppColors.secondary;
    }
  }

  Color get valueColor {
    switch (this) {
      case AppLoaderTheme.light:
        return AppColors.lightBackground;
      case AppLoaderTheme.dark:
        return AppColors.darkBackground;
    }
  }
}
