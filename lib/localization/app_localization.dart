import 'package:bloc_base_architecture/imports/localization_imports.dart';

abstract class AppLocalization extends BaseLocalization {
  AppLocalization({required super.code, required super.name, super.country});

  static AppLocalization currentLocalization() =>
      Localization.currentLocalization as AppLocalization;

  String get logIn;

  String get retry;

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

  String get home;

  String get explore;

  String get cart;

  String get favorite;

  String get profile;

  String get myOrders;

  String get deliveryAddress;

  String get setting;

  String get contactUs;

  String get logout;

  String get snacks;

  String get meal;

  String get vegan;

  String get desert;

  String get drinks;

  String get wantToAddSomething;

  String get yourFavoriteIsEmpty;

  String get addToFavorite;

  String get addToCart;

  String get removeFromFavorite;

  String get removeFromCart;

  String get checkOut;

  String get total;

  String amount(String amount);

  String get confirmOrder;

  String get shippingAddress;

  String get addressLabel;

  String get addressLabelHint;

  String get street;

  String get cityStateCountry;

  String get postalCode;

  String get addAddress;

  String get enterStreetAddress;

  String get enterAddressLabel;

  String get enterCityStateCountry;

  String get enterPostalCode;

  String get enterValidPostalCode;

  String get pleasePinLocationInMap;

  String get subTotal;

  String get taxFees;

  String get delivery;

  String get placeOrder;

  String get paymentFailed;

  String get paymentSuccess;

  String get orderPlaceSuccess;

  String get pleaseSelectAddress;

  String get cancelOrder;

  String get trackOrder;

  String get estimatedTime;

  String get viewAll;

  String get bestSellers;

  String get recommendation;

  String get noOrderYet;

  String get theme;
}
