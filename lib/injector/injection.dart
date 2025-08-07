import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_arch_config/base_arch_config.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  BaseState.setExternalResolver(<T extends Object>() => getIt<T>());
  getIt.get<BaseArchConfig>().init();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  BaseArchController get baseArchController => BaseArchController();
}
