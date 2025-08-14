import 'app_localization.dart';

class EnglishLocalization extends AppLocalization {
  EnglishLocalization() : super(code: 'en', name: 'English');

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get cancelApiRequestError => 'Request to API server was cancelled';

  @override
  String get connectionTimeoutApiRequestError =>
      'Connection timeout with API server';

  @override
  String get invalidStatusApiRequestError => 'Received invalid status code %s';

  @override
  String get receiveTimeoutApiRequestError =>
      'Receive timeout in connection with API server';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get connectionError => 'Connection error';

  /// Login

  @override
  String get logIn => 'Log In';

  @override
  String get welcome => 'Welcome';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get welcomeText2 =>
      'Whether it’s a cozy night in or a busy day,\n we’re here to deliver happiness with every bite.';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get doNotHaveAccount => 'Don’t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get emailNotEmpty => 'Email should not be blank';

  @override
  String get emailNotValid => 'Enter valid email';

  @override
  String get passwordNotEmpty => 'Password should not be blank';

  @override
  String get passwordNotStrong => 'Password must be at least 6 characters.';

  @override
  String get username => 'Username';

  @override
  String get usernameEmpty => 'Username should not be blank';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get cart => 'Cart';

  @override
  String get favorite => 'Favorite';

  @override
  String get profile => 'Profile';

  @override
  String get myOrders => 'My Orders';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get setting => 'Setting';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get logout => 'Log out';

  @override
  String get snacks => 'Snacks';

  @override
  String get meal => 'Meal';

  @override
  String get vegan => 'Vegan';

  @override
  String get desert => 'Desert';

  @override
  String get drinks => 'Drinks';
}
