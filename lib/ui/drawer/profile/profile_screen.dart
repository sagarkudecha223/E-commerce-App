import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../bloc/drawer/profile/profile_bloc.dart';
import '../../../bloc/drawer/profile/profile_contract.dart';
import '../../../core/colors.dart';
import '../../../core/dimens.dart';
import '../../../core/images.dart';
import '../../../localization/app_localization.dart';
import '../../common/app_bar.dart';
import '../../common/app_loader.dart';
import '../../common/svg_icon.dart';
import '../../common/text_field.dart';
import '../../decoration/screen_background.dart';
import '../../full_screen_error/full_screen_error.dart';

class ProfileScreen extends StatefulWidget {
  final bool isFromTab;

  const ProfileScreen({super.key, required this.isFromTab});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseState<ProfileBloc, ProfileScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFromTab
        ? _ProfileContent(bloc: bloc)
        : Scaffold(
          backgroundColor: AppColors.scaffoldBackGroundColor,
          appBar: CommonAppBar(
            title: AppLocalization.currentLocalization().profile,
          ),
          body: SafeArea(child: _ProfileContent(bloc: bloc)),
        );
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileBloc bloc;

  const _ProfileContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => bloc,
      child: BlocBuilder<ProfileBloc, ProfileData>(
        builder: (_, __) => _MainContent(bloc: bloc),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final ProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _UserContent(bloc: bloc);
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

class _UserContent extends StatelessWidget {
  final ProfileBloc bloc;

  const _UserContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ScreenBackground(),
      padding: const EdgeInsets.all(Dimens.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: Dimens.radius4xLarge,
            child: AppSvgIcon(
              Images.profile,
              color: AppColors.white,
              height: Dimens.iconLarge,
            ),
          ),
          const Gap(Dimens.spaceSmall),
          _InfoCommonView(
            label: AppLocalization.currentLocalization().username,
            value: bloc.state.userdata?.name ?? '',
          ),
          _InfoCommonView(
            label: AppLocalization.currentLocalization().email,
            value: bloc.state.userdata?.email ?? '',
          ),
          if (bloc.state.addressList != null)
            ListView.builder(
              itemCount: bloc.state.addressList?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final address = bloc.state.addressList?[index];
                return _InfoCommonView(
                  label: address?.label ?? '',
                  value: '${address?.street}, ${address?.cityStateCountry}',
                );
              },
            ),
        ],
      ),
    );
  }
}

class _InfoCommonView extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCommonView({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.space2xSmall),
      child: AppTextField(
        labelText: label,
        textEditingController: TextEditingController(text: value),
        enabled: false,
      ),
    );
  }
}
