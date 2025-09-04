import 'package:bloc_base_architecture/extension/string_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../bloc/shop/item_card/item_card_bloc.dart';
import '../../../../bloc/shop/item_card/item_card_contract.dart';
import '../../../../core/colors.dart';
import '../../../../core/dimens.dart';
import '../../../../core/image_converter.dart';
import '../../../../core/images.dart';
import '../../../../core/styles.dart';
import '../../../../model/item_model.dart';
import '../../../common/app_loader.dart';
import '../../../common/buttons/icon_button.dart';
import '../../../common/skeleton/skeleton_cart_and_fav_view.dart';
import '../../../common/skeleton/skeleton_wrapper.dart';
import '../../../common/svg_icon.dart';
import '../../../decoration/container_decoration.dart';
import '../../../full_screen_error/full_screen_error.dart';

class CardAndFavItemView extends StatefulWidget {
  final ItemModel item;

  const CardAndFavItemView({super.key, required this.item});

  @override
  State<CardAndFavItemView> createState() => _CardAndFavItemViewState();
}

class _CardAndFavItemViewState
    extends BaseState<ItemCardBloc, CardAndFavItemView> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitItemCardEvent(item: widget.item));
  }

  @override
  void didUpdateWidget(covariant CardAndFavItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      bloc.add(InitItemCardEvent(item: widget.item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemCardBloc>(
      create: (_) => bloc,
      child: BlocBuilder<ItemCardBloc, ItemCardData>(
        builder: (_, __) => _MainContent(bloc: bloc),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final ItemCardBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppSkeletonWrapper(child: SkeletonCartAndFavItemView());
      case ScreenState.content:
        return _ItemView(item: bloc.state.item!, bloc: bloc);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap: () {},
        );
    }
  }
}

class _ItemView extends StatelessWidget {
  final ItemModel item;
  final ItemCardBloc bloc;

  const _ItemView({required this.item, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ContainerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimens.containerSmall,
            child: Stack(
              children: [
                _ImageView(imageUrl: item.imageUrl),
                Row(
                  children: [
                    _IconButton(
                      isCartIcon: true,
                      onTap: () => bloc.add(AddToCardEvent()),
                      isSelected: item.isInCart,
                    ),
                    _IconButton(
                      isCartIcon: false,
                      onTap: () => bloc.add(AddToFavoriteEvent()),
                      isSelected: item.isFavorite,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: _PriceView(price: item.price),
                ),
              ],
            ),
          ),
          _NameView(name: item.name, description: item.description),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radiusLarge),
      child: CachedNetworkImage(
        imageUrl: ImageConverter.convertDriveLinkToDirect(imageUrl),
        height: Dimens.containerSmall,
        width: double.infinity,
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

class _NameView extends StatelessWidget {
  final String name;
  final String description;

  const _NameView({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.space2xSmall,
        vertical: Dimens.space3xSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name.toTitleCase,
            style: AppFontTextStyles.textStyleBold().copyWith(
              color: AppColors.textColor,
              fontSize: Dimens.fontSizeEighteen,
            ),
          ),
          Text(
            description.capitalize(),
            maxLines: 2,
            style: AppFontTextStyles.textStyleSmall().copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final bool isSelected;
  final bool isCartIcon;
  final Function() onTap;

  const _IconButton({
    required this.isSelected,
    required this.isCartIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      svgImage: isCartIcon ? Images.cart : Images.favorite,
      onTap: onTap,
      hasBorder: true,
      backgroundColor:
          isSelected ? AppColors.primaryOrange : AppColors.backgroundColor,
      imageColor: isSelected ? AppColors.white : AppColors.primaryOrange,
      imageWidth: Dimens.iconSmall,
      imageHeight: Dimens.iconSmall,
      borderRadius: Dimens.radius4xLarge,
    );
  }
}

class _PriceView extends StatelessWidget {
  final num price;

  const _PriceView({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spaceLarge),
      padding: EdgeInsets.symmetric(horizontal: Dimens.spaceXSmall),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.radius2xLarge),
          bottomLeft: Radius.circular(Dimens.radius2xLarge),
        ),
      ),
      child: Text(
        '₹ ${price.toString()}',
        style: AppFontTextStyles.textStyleBold().copyWith(
          color: AppColors.white,
          fontSize: Dimens.fontSizeSixteen,
        ),
      ),
    );
  }
}
