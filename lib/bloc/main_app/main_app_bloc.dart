import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../services/user/user_service.dart';
import 'main_app_contract.dart';

@injectable
class MainAppBloc extends BaseBloc<MainAppEvent, MainAppData> {
  MainAppBloc(this._userService) : super(initState) {
    on<InitMainAppEvent>(_initMainAppEvent);
    on<UpdateMainAppState>((event, emit) => emit(event.state));
  }

  final UserService _userService;

  static MainAppData get initState =>
      (MainAppDataBuilder()
            ..state = ScreenState.loading
            ..isLoggedIn = false
            ..errorMessage = '')
          .build();

  void _initMainAppEvent(_, __) => add(
    UpdateMainAppState(
      state.rebuild(
        (u) =>
            u
              ..isLoggedIn = _userService.isLoggedIn
              ..state = ScreenState.content,
      ),
    ),
  );
}
