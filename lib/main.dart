import 'package:flutter/material.dart';
import 'injector/injection.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MainAppScreen());
}
