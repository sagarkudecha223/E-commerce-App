import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as material;

part 'sign_up_contract.g.dart';

abstract class SignUpData implements Built<SignUpData, SignUpDataBuilder> {
  factory SignUpData([void Function(SignUpDataBuilder) updates]) = _$SignUpData;

  SignUpData._();

  ScreenState get state;

  bool get isButtonLoading;

  material.TextEditingController get emailController;

  material.TextEditingController get usernameController;

  material.TextEditingController get passwordController;

  String? get errorMessage;
}

abstract class SignUpEvent {}

class InitSignUpEvent extends SignUpEvent {}

class SignUpTapEvent extends SignUpEvent {}

class UpdateSignUpState extends SignUpEvent {
  final SignUpData state;

  UpdateSignUpState(this.state);
}
