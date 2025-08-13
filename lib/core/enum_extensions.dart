import 'package:flutter/material.dart';

import '../localization/app_localization.dart';
import 'colors.dart';
import 'enum.dart';
import 'images.dart';

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
        return AppColors.primaryOrange;
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

extension BottomNavigationOptionsExtension on BottomNavigationOptions {
  String get icon {
    switch (this) {
      case BottomNavigationOptions.shop:
        return Images.home;
      case BottomNavigationOptions.explore:
        return Images.dish;
      case BottomNavigationOptions.cart:
        return Images.cart;
      case BottomNavigationOptions.favourite:
        return Images.favorite;
      case BottomNavigationOptions.profile:
        return Images.profile;
    }
  }

  String get title {
    switch (this) {
      case BottomNavigationOptions.shop:
        return AppLocalization.currentLocalization().home;
      case BottomNavigationOptions.explore:
        return AppLocalization.currentLocalization().explore;
      case BottomNavigationOptions.cart:
        return AppLocalization.currentLocalization().cart;
      case BottomNavigationOptions.favourite:
        return AppLocalization.currentLocalization().favorite;
      case BottomNavigationOptions.profile:
        return AppLocalization.currentLocalization().profile;
    }
  }
}

extension DrawerOptionsExtension on DrawerOptions {
  String get icon {
    switch (this) {
      case DrawerOptions.profile:
        return Images.profile;
      case DrawerOptions.myOrders:
        return Images.orders;
      case DrawerOptions.deliveryAddress:
        return Images.location;
      case DrawerOptions.settings:
        return Images.settings;
      case DrawerOptions.contactUs:
        return Images.contact;
      case DrawerOptions.logout:
        return Images.logout;
    }
  }

  String get title {
    switch (this) {
      case DrawerOptions.profile:
        return AppLocalization.currentLocalization().profile;
      case DrawerOptions.myOrders:
        return AppLocalization.currentLocalization().myOrders;
      case DrawerOptions.deliveryAddress:
        return AppLocalization.currentLocalization().deliveryAddress;
      case DrawerOptions.settings:
        return AppLocalization.currentLocalization().setting;
      case DrawerOptions.contactUs:
        return AppLocalization.currentLocalization().contactUs;
      case DrawerOptions.logout:
        return AppLocalization.currentLocalization().logout;
    }
  }
}
