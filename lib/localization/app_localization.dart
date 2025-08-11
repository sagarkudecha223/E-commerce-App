import 'package:bloc_base_architecture/imports/localization_imports.dart';

abstract class AppLocalization extends BaseLocalization {
  AppLocalization({required super.code, required super.name, super.country});

  static AppLocalization currentLocalization() =>
      Localization.currentLocalization as AppLocalization;

  String get logIn;

  String get welcome;

  String get email;

  String get password;

  String get welcomeText2;

  String get signUpWithGoogle;

  String get doNotHaveAccount;

  String get signUp;

  String get emailNotEmpty;

  String get emailNotValid;

  String get passwordNotEmpty;

  String get passwordNotStrong;

  String get username;

  String get usernameEmpty;
}
