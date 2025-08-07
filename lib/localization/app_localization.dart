import 'package:bloc_base_architecture/imports/localization_imports.dart';

abstract class AppLocalization extends BaseLocalization {
  AppLocalization({required super.code, required super.name, super.country});

  static AppLocalization currentLocalization() =>
      Localization.currentLocalization as AppLocalization;
}
