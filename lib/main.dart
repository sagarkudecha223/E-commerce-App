import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'injector/injection.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const MainAppScreen());
}
