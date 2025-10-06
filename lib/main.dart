import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sizer/sizer.dart';

import 'injector/injection.dart';
import 'main_app.dart';
import 'services/payment/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await configureDependencies();
  await PaymentService.initStripe();
  runApp(
    Sizer(builder: (context, orientation, deviceType) => const MainAppScreen()),
  );
}
