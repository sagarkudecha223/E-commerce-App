import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_contract.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/dimens.dart';
import '../../core/routes.dart';
import '../../core/styles.dart';
import '../../core/toast.dart';
import '../../localization/app_localization.dart';
import '../common/app_bar.dart';
import '../common/app_loader.dart';
import '../common/app_toast.dart';
import '../common/buttons/elevated_button.dart';
import '../common/text_field.dart';
import '../decoration/screen_background.dart';
import '../full_screen_error/full_screen_error.dart';
import '../home/home_screen.dart';
import '../sign_up/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginBloc, LoginScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitLoginEvent());
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
      case AppRoutes.signUpScreen:
        navigatorKey.currentContext?.push(
          builder: (context) => SignUpScreen(),
          settings: RouteSettings(name: screen.target),
        );
        break;
      case AppRoutes.homeScreen:
        navigatorKey.currentContext?.pushAndRemoveUntil(
          builder: (context) => HomeScreen(),
          settings: RouteSettings(name: screen.target),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: CommonAppBar(title: AppLocalization.currentLocalization().logIn),
      body: SafeArea(
        child: BlocProvider<LoginBloc>(
          create: (_) => bloc,
          child: BlocBuilder<LoginBloc, LoginData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _LoginContent(bloc: bloc);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap: () {},
        );
    }
  }
}

class _LoginContent extends StatelessWidget {
  final LoginBloc bloc;

  const _LoginContent({required this.bloc});

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
            const _WelcomeText(),
            const Gap(Dimens.space4xLarge),
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
            _LoginButton(
              onTap: () => bloc.add(LoginTapEvent()),
              isLoading: bloc.state.isButtonLoading,
            ),
            const Gap(Dimens.spaceLarge),
            _GoogleButton(
              onTap: () => bloc.add(GoogleTapEvent()),
              isLoading: bloc.state.isButtonLoading,
            ),
            const Gap(Dimens.spaceLarge),
            _SignUpText(onTap: () => bloc.add(SignUpTapEvent())),
          ],
        ),
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalization.currentLocalization().welcome,
            style: AppFontTextStyles.textStyleBold().copyWith(
              fontSize: Dimens.fontSizeEighteen,
              color: AppColors.primaryOrange,
            ),
          ),
          const Gap(Dimens.spaceSmall),
          Text(
            AppLocalization.currentLocalization().welcomeText2,
            style: AppFontTextStyles.textStyleSmall(),
          ),
        ],
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

class _LoginButton extends StatelessWidget {
  final Function() onTap;
  final bool isLoading;

  const _LoginButton({required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      title: AppLocalization.currentLocalization().logIn,
      onTap: onTap,
      isLoading: isLoading,
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final Function() onTap;
  final bool isLoading;

  const _GoogleButton({required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      title: AppLocalization.currentLocalization().signUpWithGoogle,
      onTap: onTap,
      isLoading: isLoading,
    );
  }
}

class _SignUpText extends StatelessWidget {
  final Function() onTap;

  const _SignUpText({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalization.currentLocalization().doNotHaveAccount,
          style: AppFontTextStyles.textStyleMedium(),
        ),
        const Gap(Dimens.space3xSmall),
        InkWell(
          onTap: onTap,
          child: Text(
            AppLocalization.currentLocalization().signUp,
            style: AppFontTextStyles.textStyleMedium().copyWith(
              color: AppColors.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }
}
