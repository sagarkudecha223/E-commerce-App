import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();
  BaseState.setExternalResolver(<T extends Object>() => getIt<T>());
}
