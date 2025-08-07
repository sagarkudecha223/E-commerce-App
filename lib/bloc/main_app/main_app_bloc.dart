import 'dart:async';

import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../services/theme_service/theme_service.dart';
import '../../services/user/user_service.dart';
import 'main_app_contract.dart';

@injectable
class MainAppBloc extends BaseBloc<MainAppEvent, MainAppData> {
  MainAppBloc(this._userService, this._themeService) : super(initState) {
    on<InitMainAppEvent>(_initMainAppEvent);
    on<ChangeThemeEvent>(_changeTheme);
    on<UpdateMainAppState>((event, emit) => emit(event.state));
    _observeStreamSubscription();
  }

  final UserService _userService;
  final ThemeService _themeService;

  StreamSubscription<bool>? _themeStreamSubscription;

  static MainAppData get initState =>
      (MainAppDataBuilder()
            ..state = ScreenState.loading
            ..isLoggedIn = false
            ..isLightTheme = false
            ..errorMessage = '')
          .build();

  void _initMainAppEvent(_, __) => add(
    UpdateMainAppState(
      state.rebuild(
        (u) =>
            u
              ..isLoggedIn = _userService.isLoggedIn
              ..state = ScreenState.content
              ..isLightTheme = _themeService.getThemeMode(),
      ),
    ),
  );

  void _changeTheme(_, emit) {
    emit(
      state.rebuild((u) {
        _themeService.changeThemeMode();
        u.isLightTheme = _themeService.getThemeMode();
      }),
    );
    dispatchViewEvent(ChangeTheme());
  }

  _observeStreamSubscription() =>
      _themeStreamSubscription = _themeService.notifyThemeChange().listen(
        (isChange) => dispatchViewEvent(ChangeTheme()),
      );

  @override
  Future<void> close() {
    _themeStreamSubscription?.cancel();
    return super.close();
  }
}
