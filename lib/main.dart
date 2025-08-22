import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'injector/injection.dart';
import 'main_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const MainAppScreen());
}
