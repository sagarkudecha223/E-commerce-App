import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gap/gap.dart';

import '../../../bloc/drawer/setting/setting_bloc.dart';
import '../../../bloc/drawer/setting/setting_contract.dart';
import '../../../core/colors.dart';
import '../../../core/dimens.dart';
import '../../../core/styles.dart';
import '../../../localization/app_localization.dart';
import '../../common/app_bar.dart';
import '../../common/app_loader.dart';
import '../../decoration/screen_background.dart';
import '../../full_screen_error/full_screen_error.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends BaseState<SettingBloc, SettingScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitSettingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: CommonAppBar(
        title: AppLocalization.currentLocalization().setting,
      ),
      body: SafeArea(
        child: BlocProvider<SettingBloc>(
          create: (_) => bloc,
          child: BlocBuilder<SettingBloc, SettingData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final SettingBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _SettingContent(bloc: bloc);
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

class _SettingContent extends StatelessWidget {
  final SettingBloc bloc;

  const _SettingContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: ScreenBackground(),
      padding: EdgeInsets.all(Dimens.spaceLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(Dimens.spaceLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalization.currentLocalization().theme,
                style: AppFontTextStyles.textStyleBold(),
              ),
              FlutterSwitch(
                value: bloc.state.isDarkMode,
                height: Dimens.navigationBarPaddingSmall,
                width: Dimens.textFieldHeightLarge,
                activeColor: AppColors.primaryOrange,
                inactiveIcon: Icon(
                  Icons.light_mode_rounded,
                  color: AppColors.primaryOrange,
                ),
                activeIcon: Icon(
                  Icons.dark_mode_rounded,
                  color: AppColors.primaryOrange,
                ),
                onToggle: (_) => bloc.add(ToggleTapEvent()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
