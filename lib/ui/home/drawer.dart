import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_contract.dart';
import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/enum.dart';
import '../../core/enum_extensions.dart';
import '../../core/images.dart';
import '../../core/styles.dart';
import '../../model/user_model.dart';
import '../common/app_loader.dart';
import '../common/svg_icon.dart';

class DrawerContent extends StatelessWidget {
  final HomeBloc bloc;

  const DrawerContent({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.65,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        backgroundColor: AppColors.primaryOrange,
        elevation: Dimens.elevationSmall,
        shadowColor: AppColors.shadowColor,
        child: _DrawerContent(bloc: bloc),
      ).animate(effects: [SlideEffect(begin: Offset(.3, 0))]),
    );
  }
}

class _DrawerContent extends StatelessWidget {
  final HomeBloc bloc;

  const _DrawerContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spaceLarge,
        vertical: Dimens.space4xLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileView(userData: bloc.state.userData),
          const Gap(Dimens.spaceXLarge),
          _DrawerOptionView(bloc: bloc),
        ],
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final UserModel? userData;

  const _ProfileView({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: Dimens.radius2xLarge,
          child:
              userData == null
                  ? AppSvgIcon(Images.profile, height: Dimens.iconMedium)
                  : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userData!.profilePhotoUrl,
                      progressIndicatorBuilder:
                          (context, url, progress) =>
                              Center(child: AppLoader()),
                      errorWidget:
                          (context, url, error) => AppSvgIcon(
                            Images.profile,
                            height: Dimens.iconMedium,
                          ),
                    ),
                  ),
        ),
        const Gap(Dimens.spaceSmall),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData?.name ?? '',
              style: AppFontTextStyles.appbarTextStyle().copyWith(
                color: AppColors.white,
              ),
            ),
            Text(
              userData?.email ?? '',
              style: AppFontTextStyles.textStyleSmall().copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    ).animate(effects: [FadeEffect(duration: Duration(milliseconds: 500))]);
  }
}

class _DrawerOptionView extends StatelessWidget {
  final HomeBloc bloc;

  const _DrawerOptionView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder:
          (context, index) => ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.radiusSmall),
              ),
            ),
            dense: true,
            onTap:
                () => bloc.add(
                  DrawerOptionTapEvent(
                    drawerOption: DrawerOptions.values[index],
                  ),
                ),
            leading: CircleAvatar(
              backgroundColor: AppColors.white,
              child: AppSvgIcon(
                DrawerOptions.values[index].icon,
                height: Dimens.iconMedium,
              ),
            ),
            title: Text(
              DrawerOptions.values[index].title,
              style: AppFontTextStyles.textStyleMedium().copyWith(
                color: AppColors.white,
                fontSize: Dimens.fontSizeSixteen,
              ),
            ),
          ).animate(
            delay: Duration(milliseconds: 200),
            effects: [
              FadeEffect(duration: Duration(milliseconds: 200)),
              SlideEffect(
                begin: Offset(0.2, 0),
                end: Offset(0, 0),
                duration: Duration(milliseconds: 200),
              ),
            ],
          ),
      separatorBuilder: (_, _) => Divider(color: AppColors.white),
      itemCount: DrawerOptions.values.length,
    );
  }
}
