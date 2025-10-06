import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../../model/item_model.dart';
import '../common/anim/hero.dart';
import '../common/app_inkwell.dart';
import '../common/app_loader.dart';
import '../common/buttons/icon_button.dart';
import '../common/svg_icon.dart';
import '../decoration/container_decoration.dart';
import '../full_screen_error/full_screen_error.dart';
import '../order/track_order/track_order_screen.dart';
import 'item_detail/item_detail_screen.dart';

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
      case AppRoutes.itemDetailScreen:
        final Map<String, dynamic> data = screen.data as Map<String, dynamic>;
        ItemModel item = data['item'];
        String tag = data['tag'];
        navigatorKey.currentContext?.push(
          builder: (context) => ItemDetailScreen(item: item, heroTag: tag),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: bloc.state.lastOrder != null,
              child: _OrderView(bloc: bloc),
            ),
            _SliderView(bloc: bloc),
            _TitleAndViewAllView(
              title: AppLocalization.currentLocalization().bestSellers,
              onTap:
                  (item, tag) =>
                      bloc.add(ItemTapEvent(item: item, heroTag: tag)),
              itemList: bloc.state.bestSellersItems,
            ),
            const Gap(Dimens.spaceMedium),
            _TitleAndViewAllView(
              title: AppLocalization.currentLocalization().recommendation,
              onTap:
                  (item, tag) =>
                      bloc.add(ItemTapEvent(item: item, heroTag: tag)),
              itemList: bloc.state.recommendedItems,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final ShopBloc bloc;

  const _SliderView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.containerXMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CarouselSlider(
              items:
                  bloc.state.sliderItems
                      .take(8)
                      .map(
                        (item) => AppInkWell(
                          onTap:
                              () => bloc.add(
                                ItemTapEvent(item: item, heroTag: item.id),
                              ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _ImageView(
                                imageUrl: item.imageUrl,
                                heroTag: item.id,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: _PriceView(price: item.price),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _IconButton(
                                      isCartIcon: true,
                                      isSelected: item.isInCart,
                                    ),
                                    _IconButton(
                                      isCartIcon: false,
                                      isSelected: item.isFavorite,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
              carouselController: bloc.state.sliderController,
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 0.3,
                enlargeCenterPage: true,
                enlargeFactor: 0.15,
                aspectRatio: 2,
                autoPlayCurve: Curves.easeIn,
                onPageChanged:
                    (index, _) => bloc.add(SliderChangeEvent(index: index)),
              ),
            ),
          ),
          SizedBox(
            height: 12,
            child: ListView.builder(
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder:
                  (context, index) => AppInkWell(
                    onTap:
                        () => bloc.state.sliderController.animateToPage(index),
                    child: Container(
                      width: Dimens.icon2xSmall,
                      height: Dimens.icon2xSmall,
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimens.space4xSmall,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryOrange.withOpacity(
                          bloc.state.currentSliderIndex == index ? 1 : 0.4,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleAndViewAllView extends StatelessWidget {
  final String title;
  final Function(ItemModel item, String tag) onTap;
  final List<ItemModel> itemList;

  const _TitleAndViewAllView({
    required this.title,
    required this.onTap,
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.space3xSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppFontTextStyles.textStyleBold()),
              /*AppInkWell(
                onTap: onTap,
                child: Text(
                  AppLocalization.currentLocalization().viewAll,
                  style: AppFontTextStyles.textStyleMedium(),
                ),
              ),*/
            ],
          ),
        ),
        const Gap(Dimens.space3xSmall),
        SizedBox(
          height: Dimens.container2xSmall,
          width: double.infinity,
          child: ListView.builder(
            itemCount: itemList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder:
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.space4xSmall,
                  ),
                  child: AppInkWell(
                    onTap:
                        () => onTap(
                          itemList[index],
                          '$title ${itemList[index].id}',
                        ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _ImageView(
                          imageUrl: itemList[index].imageUrl,
                          width: Dimens.containerXSmall,
                          height: Dimens.containerXSmall,
                          heroTag: '$title ${itemList[index].id}',
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: _PriceView(price: itemList[index].price),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ],
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
      margin: EdgeInsets.only(bottom: Dimens.spaceSmall),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.spaceSmall,
        horizontal: Dimens.spaceSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          AppSvgIcon(Images.orders, height: Dimens.icon4xLarge),
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
                ' ${AppLocalization.currentLocalization().amount(bloc.state.lastOrder!.totalPrice.toString())}',
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
                      height: Dimens.iconLarge,
                      width: Dimens.icon6xLarge,
                    ),
              ),
            ),
          ),
          const Gap(Dimens.space2xSmall),
          AppIconButton(
            onTap: () => bloc.add(TrackOrderTapEvent()),
            svgImage: Images.deliveryBoy,
            imageHeight: Dimens.icon4xLarge,
            hasBorder: true,
          ),
        ],
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;
  final double? height;
  final double? width;

  const _ImageView({
    required this.imageUrl,
    this.height,
    this.width,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return HeroAnim(
      tag: heroTag ?? imageUrl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusMedium),
        child: CachedNetworkImage(
          imageUrl: ImageConverter.convertDriveLinkToDirect(imageUrl),
          fit: BoxFit.cover,
          height: height,
          width: width,
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

class _PriceView extends StatelessWidget {
  final num price;

  const _PriceView({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spaceMedium),
      padding: EdgeInsets.symmetric(horizontal: Dimens.spaceXSmall),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.radius2xLarge),
          bottomLeft: Radius.circular(Dimens.radius2xLarge),
        ),
      ),
      child: Text(
        AppLocalization.currentLocalization().amount(price.toString()),
        style: AppFontTextStyles.textStyleBold().copyWith(
          color: AppColors.white,
          fontSize: Dimens.fontSizeSixteen,
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final bool isSelected;
  final bool isCartIcon;

  const _IconButton({required this.isSelected, required this.isCartIcon});

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      svgImage: isCartIcon ? Images.cart : Images.favorite,
      disabledColor: isSelected ? AppColors.primaryOrange : AppColors.white,
      hasBorder: true,
      backgroundColor:
          isSelected ? AppColors.primaryOrange : AppColors.backgroundColor,
      imageColor: isSelected ? AppColors.white : AppColors.primaryOrange,
      imageWidth: Dimens.iconSmall,
      imageHeight: Dimens.iconSmall,
      borderRadius: Dimens.radius4xLarge,
    ).animate(
      effects: [ShakeEffect(), ScaleEffect(begin: Offset(0.9, 0.9))],
      value: isSelected ? 1 : 0,
      onPlay: (controller) => controller.forward(from: 0),
    );
  }
}
