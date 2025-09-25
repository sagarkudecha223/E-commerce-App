import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

import '../../bloc/shop/shop/shop_bloc.dart';
import '../../bloc/shop/shop/shop_contract.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/dimens.dart';
import '../../core/image_converter.dart';
import '../../core/images.dart';
import '../../core/routes.dart';
import '../../core/styles.dart';
import '../../localization/app_localization.dart';
import '../common/app_loader.dart';
import '../common/buttons/icon_button.dart';
import '../common/svg_icon.dart';
import '../decoration/container_decoration.dart';
import '../full_screen_error/full_screen_error.dart';
import '../order/track_order/track_order_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends BaseState<ShopBloc, ShopScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitShopEvent());
  }

  @override
  void onViewEvent(ViewAction event) {
    switch (event.runtimeType) {
      case const (NavigateScreen):
        _buildHandleActionEvent(event as NavigateScreen);
    }
  }

  void _buildHandleActionEvent(NavigateScreen screen) {
    switch (screen.target) {
      case AppRoutes.trackOrderScreen:
        navigatorKey.currentContext?.push(
          builder:
              (context) => TrackOrderScreen(destination: screen.data as LatLng),
          settings: RouteSettings(name: screen.target),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopBloc>(
      create: (_) => bloc,
      child: BlocBuilder<ShopBloc, ShopData>(
        builder: (_, __) => _MainContent(bloc: bloc),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final ShopBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _ShopContent(bloc: bloc);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap: () {},
        );
    }
  }
}

class _ShopContent extends StatelessWidget {
  final ShopBloc bloc;

  const _ShopContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimens.space4xSmall,
        horizontal: Dimens.space3xSmall,
      ),
      child: Visibility(
        visible: bloc.state.lastOrder != null,
        child: _OrderView(bloc: bloc),
      ),
    );
  }
}

class _OrderView extends StatelessWidget {
  final ShopBloc bloc;

  const _OrderView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration(
        backgroundColor: AppColors.secondaryYellow,
      ),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.spaceSmall,
        horizontal: Dimens.spaceSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          AppSvgIcon(Images.orders, height: Dimens.icon6xLarge),
          const Gap(Dimens.spaceMedium),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: Dimens.iconXSmall,
                    color: AppColors.textColor,
                  ),
                  const Gap(Dimens.space4xSmall),
                  Text(
                    bloc.state.lastOrder?.address.label ?? '',
                    style: AppFontTextStyles.textStyleBold(),
                  ),
                ],
              ),
              Text(
                AppLocalization.currentLocalization().amount(
                  bloc.state.lastOrder!.totalPrice.toString(),
                ),
                style: AppFontTextStyles.textStyleBold(),
              ),
            ],
          ),
          const Gap(Dimens.space2xSmall),
          Expanded(
            child: SizedBox(
              height: Dimens.navigationBarHeight,
              child: ListView.builder(
                itemCount: bloc.state.lastOrder!.items.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder:
                    (context, index) => _ImageView(
                      imageUrl: bloc.state.lastOrder!.items[index].imageUrl,
                    ),
              ),
            ),
          ),
          const Gap(Dimens.space2xSmall),
          AppIconButton(
            onTap: () => bloc.add(TrackOrderTapEvent()),
            svgImage: Images.deliveryBoy,
            imageHeight: Dimens.icon3xLarge,
            hasBorder: true,
          ),
        ],
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  final String imageUrl;

  const _ImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.space4xSmall),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusMedium),
        child: CachedNetworkImage(
          imageUrl: ImageConverter.convertDriveLinkToDirect(imageUrl),
          fit: BoxFit.cover,
          height: Dimens.iconXLarge,
          width: Dimens.icon6xLarge,
          alignment: Alignment.center,
          filterQuality: FilterQuality.medium,
          progressIndicatorBuilder:
              (context, url, progress) => Center(child: AppLoader()),
          errorWidget:
              (context, url, error) =>
                  AppSvgIcon(Images.snacks, height: Dimens.iconMedium),
        ),
      ),
    );
  }
}
