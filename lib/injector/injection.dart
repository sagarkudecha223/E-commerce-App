import 'package:bloc_base_architecture/api/network/network_info.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_arch_config/base_arch_config.dart';
import '../services/theme_service/theme_service.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  BaseState.setExternalResolver(<T extends Object>() => getIt<T>());
  getIt.get<BaseArchConfig>().init();
  getIt.get<ThemeService>().getThemeMode();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  BaseArchController get baseArchController => BaseArchController();

  @singleton
  NetworkInfoImpl get networkInfoImpl => NetworkInfoImpl();
}
