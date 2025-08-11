import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/regex.dart';
import '../../core/routes.dart';
import '../../localization/app_localization.dart';
import '../../services/firebase/auth_service.dart';
import 'login_contract.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginData> {
  LoginBloc(this._firebaseAuthService)
    : super(initState) {
    on<InitLoginEvent>(_initLoginEvent);
    on<LoginTapEvent>(_loginTapEvent);
    on<GoogleTapEvent>(_googleTapEvent);
    on<SignUpTapEvent>(_signUpTapEvent);
    on<UpdateLoginState>((event, emit) => emit(event.state));
  }

  final FirebaseAuthService _firebaseAuthService;

  static LoginData get initState =>
      (LoginDataBuilder()
            ..state = ScreenState.loading
            ..isButtonLoading = false
            ..passwordController = TextEditingController()
            ..emailController = TextEditingController()
            ..errorMessage = '')
          .build();

  void _initLoginEvent(_, __) => add(
    UpdateLoginState(state.rebuild((u) => u.state = ScreenState.content)),
  );

  void _loginTapEvent(_, __) async {
    if (state.emailController.text.isEmpty) {
      _displayMessage(
        message: AppLocalization.currentLocalization().emailNotEmpty,
      );
    } else if (!Regex.emailRegex.hasMatch(state.emailController.text)) {
      _displayMessage(
        message: AppLocalization.currentLocalization().emailNotValid,
      );
    } else if (state.passwordController.text.isEmpty) {
      _displayMessage(
        message: AppLocalization.currentLocalization().passwordNotEmpty,
      );
    } else {
      add(UpdateLoginState(state.rebuild((u) => u.isButtonLoading = true)));
      await _firebaseAuthService
          .signInWithEmail(
            state.emailController.text,
            state.passwordController.text,
          )
          .then((response) {
            if (response != null) {
              printLog(message: response);
            }
          })
          .catchError((error) {
            _displayMessage(message: error.toString());
          });
    }
    add(UpdateLoginState(state.rebuild((u) => u.isButtonLoading = false)));
  }

  void _googleTapEvent(_, __) async {
    add(UpdateLoginState(state.rebuild((u) => u.isButtonLoading = true)));
    await _firebaseAuthService
        .signInWithGoogle()
        .then((response) {
          if (response != null) {
            dispatchViewEvent(NavigateScreen(AppRoutes.homeScreen));
          }
        })
        .catchError((error) {
          _displayMessage(message: error.toString());
        });
    add(UpdateLoginState(state.rebuild((u) => u.isButtonLoading = false)));
  }

  void _signUpTapEvent(_, __) =>
      dispatchViewEvent(NavigateScreen(AppRoutes.signUpScreen));

  _displayMessage({required String message}) {
    dispatchViewEvent(
      DisplayMessage(type: DisplayMessageType.toast, message: message),
    );
  }
}
