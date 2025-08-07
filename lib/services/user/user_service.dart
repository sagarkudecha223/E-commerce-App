import 'package:injectable/injectable.dart';

import '../../core/cache/preference_store.dart';
import '../../core/enum.dart';

@singleton
class UserService {
  final PreferenceStore _preferenceStore;

  UserService(this._preferenceStore);

  Future<bool> signOut() async {
    await _preferenceStore.resetValue();
    return true;
  }

  Future<bool> setUserLoggedIn() async => await _preferenceStore.setValue(
    SharedPreferenceStore.IS_USER_LOGGED_IN,
    true,
  );

  Future<bool> setTheme({required bool isDarkTheme}) async =>
      await _preferenceStore.setValue(
        SharedPreferenceStore.IS_DARK_THEME,
        isDarkTheme,
      );

  bool get isLoggedIn =>
      _preferenceStore.getValue(SharedPreferenceStore.IS_USER_LOGGED_IN) ??
      false;

  bool get isDarkTheme =>
      _preferenceStore.getValue(SharedPreferenceStore.IS_DARK_THEME) ?? false;
}
