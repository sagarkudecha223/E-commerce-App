import 'dart:convert';

import 'package:bloc_base_architecture/imports/api_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PaymentService {
  final RestApiClient _apiClient;

  PaymentService(this._apiClient);

  static const paymentServer =
      'https://stripe-backend-git-main-sagarkudecha223s-projects.vercel.app/api/create-payment-intent';

  static initStripe() async {
    Stripe.publishableKey =
        'pk_test_51S8g2KAWJSiu8PZEVr3AaKiJ7enYGoTYjX000NuEhC7BHiG20LpMvSyyZHZkbXaJVRVdlLVTa5o1P3Afns7lz1Ar003MJ4c4So';
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
  }

  makePayment({required int amount}) async {
    try {
      // 1. Call backend to create PaymentIntent
      final clientSecret = await _createPaymentIntent(amount);

      // 2. Init PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Demo, Inc.',
          style: ThemeMode.light,
        ),
      );

      // 3. Present PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } on StripeException catch (e) {
      return 'Stripe error: ${e.error.localizedMessage}';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> _createPaymentIntent(int amount) async {
    /*   🔹 Use http://10.0.2.2:4242 for Android Emulator,
         🔹 Use http://localhost:4242 if running on iOS Simulator,
         🔹 Use your LAN IP http://192.168.1.100:4242 for real devices.  */

    final resp = await _apiClient.dio.post(
      paymentServer,
      data: jsonEncode({'amount': amount}),
    );

    final clientSecret = resp.data["clientSecret"];
    return clientSecret;
  }
}
