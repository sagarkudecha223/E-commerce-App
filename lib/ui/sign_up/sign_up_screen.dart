import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../bloc/sign_up/sign_up_bloc.dart';
import '../../bloc/sign_up/sign_up_contract.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/dimens.dart';
import '../../core/routes.dart';
import '../../core/toast.dart';
import '../../localization/app_localization.dart';
import '../common/app_bar.dart';
import '../common/app_loader.dart';
import '../common/app_toast.dart';
import '../common/buttons/elevated_button.dart';
import '../common/text_field.dart';
import '../decoration/screen_background.dart';
import '../full_screen_error/full_screen_error.dart';
import '../login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseState<SignUpBloc, SignUpScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitSignUpEvent());
  }

  @override
  void onViewEvent(ViewAction event) {
    switch (event.runtimeType) {
      case const (NavigateScreen):
        _buildHandleActionEvent(event as NavigateScreen);
      case const (DisplayMessage):
        _buildHandleMessage(event as DisplayMessage);
    }
  }

  void _buildHandleMessage(DisplayMessage displayMessage) {
    final message = displayMessage.message;
    final type = displayMessage.type;
    switch (type) {
      case DisplayMessageType.toast:
        showToast(AppToast(message: message!), context);
      default:
        break;
    }
  }

  void _buildHandleActionEvent(NavigateScreen screen) {
    switch (screen.target) {
      case AppRoutes.homeScreen:
        navigatorKey.currentContext?.pushAndRemoveUntil(
          builder: (context) => LoginScreen(),
          settings: RouteSettings(name: screen.target),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: CommonAppBar(title: AppLocalization.currentLocalization().signUp),
      body: SafeArea(
        child: BlocProvider<SignUpBloc>(
          create: (_) => bloc,
          child: BlocBuilder<SignUpBloc, SignUpData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final SignUpBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _SignUpContent(bloc: bloc);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap: () {
            /// NOTE : retry event : bloc.add(<event_name>)
          },
        );
    }
  }
}

class _SignUpContent extends StatelessWidget {
  final SignUpBloc bloc;

  const _SignUpContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimens.spaceLarge),
      height: double.infinity,
      decoration: ScreenBackground(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(Dimens.spaceXLarge),
            _TextField(
              title: AppLocalization.currentLocalization().username,
              controller: bloc.state.usernameController,
            ),
            const Gap(Dimens.spaceXLarge),
            _TextField(
              title: AppLocalization.currentLocalization().email,
              controller: bloc.state.emailController,
            ),
            const Gap(Dimens.spaceXLarge),
            _TextField(
              title: AppLocalization.currentLocalization().password,
              controller: bloc.state.passwordController,
              obscureText: true,
            ),
            const Gap(Dimens.space4xLarge),
            _SignUpButton(
              onTap: () => bloc.add(SignUpTapEvent()),
              isLoading: bloc.state.isButtonLoading,
            ),
            const Gap(Dimens.spaceLarge),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool obscureText;

  const _TextField({
    required this.controller,
    required this.title,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      labelText: title,
      textEditingController: controller,
      textInputAction:
          obscureText ? TextInputAction.done : TextInputAction.next,
      keyboardType:
          obscureText
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
      obscureText: obscureText,
      suffixIconType:
          obscureText ? TextFieldSuffixIconType.showObscureText : null,
      onTapOutside: () {},
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final Function() onTap;
  final bool isLoading;

  const _SignUpButton({required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      title: AppLocalization.currentLocalization().signUp,
      onTap: onTap,
      isLoading: isLoading,
    );
  }
}
