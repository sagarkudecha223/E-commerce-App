import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:built_value/built_value.dart';

part 'setting_contract.g.dart';

abstract class SettingData implements Built<SettingData, SettingDataBuilder> {
  factory SettingData([void Function(SettingDataBuilder) updates]) =
      _$SettingData;

  SettingData._();

  ScreenState get state;

  bool get isDarkMode;

  String? get errorMessage;
}

abstract class SettingEvent {}

class InitSettingEvent extends SettingEvent {}

class ToggleTapEvent extends SettingEvent {}

class UpdateSettingState extends SettingEvent {
  final SettingData state;

  UpdateSettingState(this.state);
}
