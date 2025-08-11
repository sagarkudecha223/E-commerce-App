import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as material;

part 'login_contract.g.dart';

abstract class LoginData implements Built<LoginData, LoginDataBuilder> {
  factory LoginData([void Function(LoginDataBuilder) updates]) = _$LoginData;

  LoginData._();

  ScreenState get state;

  bool get isButtonLoading;

  material.TextEditingController get emailController;

  material.TextEditingController get passwordController;

  String? get errorMessage;
}

abstract class LoginEvent {}

class InitLoginEvent extends LoginEvent {}

class LoginTapEvent extends LoginEvent {}

class GoogleTapEvent extends LoginEvent {}

class SignUpTapEvent extends LoginEvent {}

class UpdateLoginState extends LoginEvent {
  final LoginData state;

  UpdateLoginState(this.state);
}
