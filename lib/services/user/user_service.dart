import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../core/cache/preference_store.dart';
import '../../core/enum.dart';
import '../../model/address_model.dart';
import '../../model/user_model.dart';

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

  Future<void> saveUser(UserModel user) async {
    String jsonUser = jsonEncode(user.toJson());
    await _preferenceStore.setValue(SharedPreferenceStore.USER_INFO, jsonUser);
  }

  Future<void> addFavorite(String productId) async {
    UserModel? user = await getUser();

    if (user != null && !user.favoriteItems.contains(productId)) {
      final updatedUser = user.copyWith(
        favoriteItems: [...user.favoriteItems, productId],
      );
      await saveUser(updatedUser);
    }
  }

  void addingNewAddress({required Address address}) async {
    UserModel? user = await getUser();

    if (user != null) {
      final updatedUser = user.copyWith(
        addressList: [...user.addressList, address],
      );

      await saveUser(updatedUser);
    }
  }

  Future<UserModel?> getUser() async {
    String? jsonUser = _preferenceStore.getValue(
      SharedPreferenceStore.USER_INFO,
    );
    if (jsonUser == null) return null;
    return UserModel.fromJson(jsonDecode(jsonUser));
  }

  bool get isLoggedIn =>
      _preferenceStore.getValue(SharedPreferenceStore.IS_USER_LOGGED_IN) ??
      false;

  bool get isDarkTheme =>
      _preferenceStore.getValue(SharedPreferenceStore.IS_DARK_THEME) ?? false;
}
