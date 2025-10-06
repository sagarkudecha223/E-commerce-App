import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

import '../../../bloc/drawer/my_order/my_order_bloc.dart';
import '../../../bloc/drawer/my_order/my_order_contract.dart';
import '../../../core/colors.dart';
import '../../../core/constants.dart';
import '../../../core/dimens.dart';
import '../../../core/image_converter.dart';
import '../../../core/images.dart';
import '../../../core/routes.dart';
import '../../../core/styles.dart';
import '../../../localization/app_localization.dart';
import '../../../model/item_model.dart';
import '../../../model/order_model.dart';
import '../../common/app_bar.dart';
import '../../common/app_loader.dart';
import '../../common/buttons/elevated_button.dart';
import '../../common/svg_icon.dart';
import '../../decoration/container_decoration.dart';
import '../../decoration/screen_background.dart';
import '../../order/track_order/track_order_screen.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends BaseState<MyOrderBloc, MyOrderScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitMyOrderEvent());
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: CommonAppBar(
        title: AppLocalization.currentLocalization().myOrders,
      ),
      body: SafeArea(
        child: BlocProvider<MyOrderBloc>(
          create: (_) => bloc,
          child: BlocBuilder<MyOrderBloc, MyOrderData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final MyOrderBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.content:
        return _OrderContent(bloc: bloc);
      default:
        return const AppLoader();
    }
  }
}

class _OrderContent extends StatelessWidget {
  final MyOrderBloc bloc;

  const _OrderContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ScreenBackground(),
      height: double.infinity,
      padding: EdgeInsets.all(Dimens.spaceSmall),
      child: bloc.state.orderList.isNotEmpty? ListView.builder(
        itemBuilder:
            (context, index) =>
                _OrderItemView(item: bloc.state.orderList[index], bloc: bloc),
        itemCount: bloc.state.orderList.length,
        shrinkWrap: true,
      ) : Center(child: Text(AppLocalization.currentLocalization().noOrderYet)),
    );
  }
}

class _OrderItemView extends StatelessWidget {
  final OrderModel item;
  final MyOrderBloc bloc;

  const _OrderItemView({required this.item, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration(),
      margin: EdgeInsets.symmetric(vertical: Dimens.space4xSmall),
      padding: EdgeInsets.all(Dimens.space3xSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ItemListView(items: item.items),
          Divider(
            color: AppColors.borderColor,
            endIndent: Dimens.space3xSmall,
            indent: Dimens.space3xSmall,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spaceSmall,
              vertical: Dimens.space4xSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PriceView(price: item.totalPrice.toString()),
                    _AddressView(address: item.address.label),
                  ],
                ),
                const Gap(Dimens.space4xSmall),
                _ButtonView(
                  onCancelTap:
                      () => bloc.add(CancelOrderTapEvent(orderModel: item)),
                  onTrackTap:
                      () => bloc.add(TrackOrderTapEvent(orderModel: item)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceView extends StatelessWidget {
  final String price;

  const _PriceView({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalization.currentLocalization().amount(price),
      style: AppFontTextStyles.textStyleBold().copyWith(
        color: AppColors.textColor,
      ),
    );
  }
}

class _AddressView extends StatelessWidget {
  final String address;

  const _AddressView({required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_rounded,
          color: AppColors.primaryOrange,
          size: Dimens.iconSmall,
        ),
        const Gap(Dimens.space4xSmall),
        Text(
          address,
          style: AppFontTextStyles.textStyleBold().copyWith(
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}

class _ButtonView extends StatelessWidget {
  final Function() onCancelTap;
  final Function() onTrackTap;

  const _ButtonView({required this.onCancelTap, required this.onTrackTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppElevatedButton(
            onTap: onCancelTap,
            title: AppLocalization.currentLocalization().cancelOrder,
          ),
        ),
        const Gap(Dimens.spaceSmall),
        Expanded(
          child: AppElevatedButton(
            onTap: onTrackTap,
            title: AppLocalization.currentLocalization().trackOrder,
          ),
        ),
      ],
    );
  }
}

class _ItemListView extends StatelessWidget {
  final List<ItemModel> items;

  const _ItemListView({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Dimens.containerXMedium,
        mainAxisExtent: 200,
        crossAxisSpacing: Dimens.spaceXSmall,
        mainAxisSpacing: Dimens.spaceXSmall,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _ItemView(item: items[index]),
    );
  }
}

class _ItemView extends StatelessWidget {
  final ItemModel item;

  const _ItemView({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _ImageView(imageUrl: item.imageUrl)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceXMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name,
                style: AppFontTextStyles.textStyleBold().copyWith(
                  color: AppColors.textColor,
                ),
              ),
              const Gap(Dimens.space3xSmall),
              Text(
                'x ${item.cartQuantity.toString()}',
                style: AppFontTextStyles.textStyleBold(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageView extends StatelessWidget {
  final String imageUrl;

  const _ImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radiusLarge),
      child: CachedNetworkImage(
        imageUrl: ImageConverter.convertDriveLinkToDirect(imageUrl),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        filterQuality: FilterQuality.medium,
        progressIndicatorBuilder:
            (context, url, progress) => Center(child: AppLoader()),
        errorWidget:
            (context, url, error) =>
                AppSvgIcon(Images.snacks, height: Dimens.iconMedium),
      ),
    );
  }
}
