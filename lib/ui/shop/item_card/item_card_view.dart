import 'package:bloc_base_architecture/extension/string_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../bloc/shop/item_card/item_card_bloc.dart';
import '../../../bloc/shop/item_card/item_card_contract.dart';
import '../../../core/colors.dart';
import '../../../core/dimens.dart';
import '../../../core/image_converter.dart';
import '../../../core/images.dart';
import '../../../core/styles.dart';
import '../../../model/item_model.dart';
import '../../common/app_loader.dart';
import '../../common/buttons/icon_button.dart';
import '../../common/skeleton/skeleton_item_view.dart';
import '../../common/skeleton/skeleton_wrapper.dart';
import '../../decoration/container_decoration.dart';
import '../../common/svg_icon.dart';
import '../../full_screen_error/full_screen_error.dart';

class ItemCardView extends StatefulWidget {
  final ItemModel item;

  const ItemCardView({super.key, required this.item});

  @override
  State<ItemCardView> createState() => _ItemCardViewState();
}

class _ItemCardViewState extends BaseState<ItemCardBloc, ItemCardView> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitItemCardEvent(item: widget.item));
  }

  @override
  void didUpdateWidget(covariant ItemCardView oldWidget) {
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
        return const AppSkeletonWrapper(child: SkeletonItemView());
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
      margin: const EdgeInsets.symmetric(vertical: Dimens.space2xSmall),
      height: Dimens.containerSmall,
      decoration: ContainerDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageView(imageUrl: item.imageUrl),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spaceSmall,
                vertical: Dimens.spaceMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NameView(name: item.name, description: item.description),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '₹ ${item.price.toString()}',
                        style: AppFontTextStyles.textStyleBold().copyWith(
                          color: AppColors.primaryOrange,
                          fontSize: Dimens.fontSizeEighteen,
                        ),
                      ),
                      const Spacer(),
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
                ],
              ),
            ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radiusLarge),
      child: CachedNetworkImage(
        imageUrl: ImageConverter.convertDriveLinkToDirect(imageUrl),
        height: Dimens.containerSmall,
        width: MediaQuery.of(context).size.width * 0.4,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          style: AppFontTextStyles.textStyleSmall(),
        ),
      ],
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
      backgroundColor: isSelected ? AppColors.lightRed : AppColors.transparent,
      imageColor: isSelected ? AppColors.white : AppColors.primaryOrange,
      imageWidth: Dimens.iconSmall,
      imageHeight: Dimens.iconSmall,
      borderRadius: Dimens.radius4xLarge,
    );
  }
}
