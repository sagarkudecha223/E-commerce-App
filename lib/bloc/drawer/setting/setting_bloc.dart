import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../../core/colors.dart';
import '../../../services/theme_service/theme_service.dart';
import 'setting_contract.dart';

@injectable
class SettingBloc extends BaseBloc<SettingEvent, SettingData> {
  SettingBloc(this._themeService) : super(initState) {
    on<InitSettingEvent>(_initSettingEvent);
    on<ToggleTapEvent>(_toggleTapEvent);
    on<UpdateSettingState>((event, emit) => emit(event.state));
  }

  final ThemeService _themeService;

  static SettingData get initState =>
      (SettingDataBuilder()
            ..state = ScreenState.loading
            ..isDarkMode = !AppColors.isLightTheme
            ..errorMessage = '')
          .build();

  void _initSettingEvent(_, __) {
    add(
      UpdateSettingState(
        state.rebuild(
          (u) =>
              u
                ..isDarkMode = !AppColors.isLightTheme
                ..state = ScreenState.content,
        ),
      ),
    );
  }

  _toggleTapEvent(_, __) {
    _themeService.changeTheme();
    add(
      UpdateSettingState(
        state.rebuild((u) => u.isDarkMode = !AppColors.isLightTheme),
      ),
    );
  }
}
