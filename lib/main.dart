import 'package:flutter/material.dart';
import 'injector/injection.dart';
import 'main_app.dart';

void main() {
  configureDependencies();
  runApp(const MainAppScreen());
}
