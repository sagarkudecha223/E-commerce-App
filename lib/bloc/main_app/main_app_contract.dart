import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

part 'main_app_contract.g.dart';

abstract class MainAppData implements Built<MainAppData, MainAppDataBuilder> {
  factory MainAppData([void Function(MainAppDataBuilder) updates]) =
      _$MainAppData;

  MainAppData._();

  ScreenState get state;

  bool get isLoggedIn;

  bool get isLightTheme;

  String? get errorMessage;
}

abstract class MainAppEvent {}

class InitMainAppEvent extends MainAppEvent {}

class ChangeThemeEvent extends MainAppEvent {}

class UpdateMainAppState extends MainAppEvent {
  final MainAppData state;

  UpdateMainAppState(this.state);
}
