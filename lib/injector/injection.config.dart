// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bloc_base_architecture/api/network/network_info.dart' as _i921;
import 'package:bloc_base_architecture/base_arch_controller/base_arch_controller.dart'
    as _i345;
import 'package:bloc_base_architecture/imports/core_imports.dart' as _i874;
import 'package:demo_app/base_arch_config/base_arch_config.dart' as _i338;
import 'package:demo_app/bloc/full_screen_error/full_screen_error_bloc.dart'
    as _i297;
import 'package:demo_app/bloc/login/login_bloc.dart' as _i197;
import 'package:demo_app/bloc/main_app/main_app_bloc.dart' as _i857;
import 'package:demo_app/core/cache/preference_store.dart' as _i931;
import 'package:demo_app/injector/injection.dart' as _i609;
import 'package:demo_app/services/firebase/auth_service.dart' as _i265;
import 'package:demo_app/services/firebase/firebase_data_service.dart' as _i693;
import 'package:demo_app/services/theme_service/theme_service.dart' as _i1058;
import 'package:demo_app/services/user/user_service.dart' as _i800;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i874.BaseArchController>(
      () => registerModule.baseArchController,
    );
    gh.singleton<_i921.NetworkInfoImpl>(() => registerModule.networkInfoImpl);
    gh.singleton<_i265.FirebaseAuthService>(() => _i265.FirebaseAuthService());
    gh.singleton<_i693.FirebaseDataService>(() => _i693.FirebaseDataService());
    gh.factory<_i197.LoginBloc>(
      () => _i197.LoginBloc(gh<_i265.FirebaseAuthService>()),
    );
    gh.singleton<_i338.BaseArchConfig>(
      () => _i338.BaseArchConfig(gh<_i345.BaseArchController>()),
    );
    gh.factory<_i297.FullScreenErrorBloc>(
      () => _i297.FullScreenErrorBloc(gh<_i921.NetworkInfoImpl>()),
    );
    gh.singleton<_i931.PreferenceStore>(
      () => _i931.PreferenceStore(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i1058.ThemeService>(
      () => _i1058.ThemeService(gh<_i931.PreferenceStore>()),
    );
    gh.singleton<_i800.UserService>(
      () => _i800.UserService(gh<_i931.PreferenceStore>()),
    );
    gh.factory<_i857.MainAppBloc>(
      () => _i857.MainAppBloc(gh<_i800.UserService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i609.RegisterModule {}
