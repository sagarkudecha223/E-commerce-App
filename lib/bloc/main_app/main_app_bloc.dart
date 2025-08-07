import 'package:bloc_base_architecture/core/base_bloc.dart';
import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:injectable/injectable.dart';

import 'main_app_contract.dart';

@injectable
class MainAppBloc extends BaseBloc<MainAppEvent, MainAppData> {
  MainAppBloc() : super(initState) {
    on<InitMainAppEvent>(_initMainAppEvent);
    on<UpdateMainAppState>((event, emit) => emit(event.state));
  }

  static MainAppData get initState =>
      (MainAppDataBuilder()
            ..state = ScreenState.loading
            ..errorMessage = '')
          .build();

  void _initMainAppEvent(_, __) {}
}
