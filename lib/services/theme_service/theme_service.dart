import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/cache/preference_store.dart';
import '../../core/colors.dart';
import '../../core/enum.dart';

@singleton
class ThemeService {
  ThemeService(this._preferenceStore);

  final PreferenceStore _preferenceStore;

  final _themeChanged = StreamController<bool>.broadcast();

  Stream<bool> notifyThemeChange() => _themeChanged.stream;

  void changeThemeMode() {
    final isLightTheme = _changeTheme();
    _themeChanged.add(isLightTheme);
  }

  bool getThemeMode() {
    AppColors.isLightTheme =
        _preferenceStore.getValue(SharedPreferenceStore.IS_DARK_THEME) ?? false;
    return AppColors.isLightTheme;
  }

  bool _changeTheme() {
    _preferenceStore.setValue(
      SharedPreferenceStore.IS_DARK_THEME,
      !AppColors.isLightTheme,
    );
    AppColors.isLightTheme = !AppColors.isLightTheme;
    return AppColors.isLightTheme;
  }
}
