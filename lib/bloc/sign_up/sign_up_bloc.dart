import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/regex.dart';
import '../../core/routes.dart';
import '../../localization/app_localization.dart';
import '../../services/firebase/auth_service.dart';
import 'sign_up_contract.dart';

@injectable
class SignUpBloc extends BaseBloc<SignUpEvent, SignUpData> {
  SignUpBloc(this._firebaseAuthService) : super(initState) {
    on<InitSignUpEvent>(_initSignUpEvent);
    on<SignUpTapEvent>(_signUpTapEvent);
    on<UpdateSignUpState>((event, emit) => emit(event.state));
  }

  final FirebaseAuthService _firebaseAuthService;

  static SignUpData get initState =>
      (SignUpDataBuilder()
            ..state = ScreenState.loading
            ..isButtonLoading = false
            ..usernameController = TextEditingController()
            ..passwordController = TextEditingController()
            ..emailController = TextEditingController()
            ..errorMessage = '')
          .build();

  void _initSignUpEvent(_, __) => add(
    UpdateSignUpState(state.rebuild((u) => u.state = ScreenState.content)),
  );

  void _signUpTapEvent(_, __) async {
    if (state.usernameController.text.trim().isEmpty) {
      _displayMessage(
        message: AppLocalization.currentLocalization().usernameEmpty,
      );
    } else if (state.emailController.text.trim().isEmpty) {
      _displayMessage(
        message: AppLocalization.currentLocalization().emailNotEmpty,
      );
    } else if (!Regex.emailRegex.hasMatch(state.emailController.text.trim())) {
      _displayMessage(
        message: AppLocalization.currentLocalization().emailNotValid,
      );
    } else if (state.passwordController.text.trim().isEmpty) {
      _displayMessage(
        message: AppLocalization.currentLocalization().passwordNotEmpty,
      );
    } else if (state.passwordController.text.trim().length < 6) {
      _displayMessage(
        message: AppLocalization.currentLocalization().passwordNotStrong,
      );
    } else {
      add(UpdateSignUpState(state.rebuild((u) => u.isButtonLoading = true)));
      await _firebaseAuthService
          .signUpWithEmail(
            state.emailController.text,
            state.passwordController.text,
            state.usernameController.text,
          )
          .then((response) {
            if (response != null) {
              dispatchViewEvent(NavigateScreen(AppRoutes.loginScreen));
            }
          })
          .catchError((error) {
            _displayMessage(message: error.toString());
          });
    }
    add(UpdateSignUpState(state.rebuild((u) => u.isButtonLoading = false)));
  }

  _displayMessage({required String message}) {
    dispatchViewEvent(
      DisplayMessage(type: DisplayMessageType.toast, message: message),
    );
  }
}
