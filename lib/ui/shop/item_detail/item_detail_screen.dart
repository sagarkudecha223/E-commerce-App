import 'package:bloc_base_architecture/extension/string_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../bloc/shop/item_detail/item_detail_bloc.dart';
import '../../../bloc/shop/item_detail/item_detail_contract.dart';
import '../../../core/colors.dart';
import '../../../core/dimens.dart';
import '../../../core/images.dart';
import '../../../core/styles.dart';
import '../../../localization/app_localization.dart';
import '../../../model/item_model.dart';
import '../../common/app_bar.dart';
import '../../common/app_loader.dart';
import '../../common/buttons/elevated_button.dart';
import '../../common/buttons/icon_button.dart';
import '../../common/cache_network_image_view.dart';
import '../../common/svg_icon.dart';
import '../../decoration/screen_background.dart';
import '../../full_screen_error/full_screen_error.dart';

class ItemDetailScreen extends StatefulWidget {
  final ItemModel item;
  final String heroTag;

  const ItemDetailScreen({super.key, required this.item, this.heroTag = ''});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState
    extends BaseState<ItemDetailBloc, ItemDetailScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitItemDetailEvent(item: widget.item, heroTag: widget.heroTag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.item.name),
      backgroundColor: AppColors.scaffoldBackGroundColor,
      body: SafeArea(
        child: BlocProvider<ItemDetailBloc>(
          create: (_) => bloc,
          child: BlocBuilder<ItemDetailBloc, ItemDetailData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final ItemDetailBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _ItemDetailContent(bloc: bloc);
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

class _ItemDetailContent extends StatelessWidget {
  final ItemDetailBloc bloc;

  const _ItemDetailContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    final item = bloc.state.item!;
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.spaceSmall,
        horizontal: Dimens.spaceLarge,
      ),
      decoration: ScreenBackground(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _ImageView(imageUrl: item.imageUrl, heroTag: bloc.state.heroTag),
            const Gap(Dimens.space2xSmall),
            _PriceView(bloc: bloc),
            const Gap(Dimens.space2xSmall),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    item.description.capitalize(),
                    style: AppFontTextStyles.textStyleMedium(),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const Gap(Dimens.spaceLarge),
            _CommonButton(
              isCart: false,
              onTap: () => bloc.add(AddToFavoriteEvent()),
              isSelected: item.isFavorite,
            ),
            const Gap(Dimens.spaceLarge),
            _CommonButton(
              isCart: true,
              onTap: () => bloc.add(AddToCardEvent()),
              isSelected: item.isInCart,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const _ImageView({required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CacheNetworkImageView(
        imageUrl: imageUrl,
        heroTag: heroTag,
        height: Dimens.containerXMedium,
      ),
    );
  }
}

class _PriceView extends StatelessWidget {
  final ItemDetailBloc bloc;

  const _PriceView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    final item = bloc.state.item!;
    return Row(
      children: [
        Text(
          AppLocalization.currentLocalization().amount(item.price.toString()),
          style: AppFontTextStyles.textStyleBold().copyWith(
            color: AppColors.primaryOrange,
            fontSize: Dimens.fontSizeEighteen,
          ),
        ),
        const Spacer(),
        _AddRemoveButton(
          isAddButton: false,
          onTap:
              () =>
                  item.cartQuantity == 0
                      ? null
                      : bloc.add(ChangeQuantityEvent(isAdding: false)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.space2xSmall),
          child: Text(
            '${item.cartQuantity < 10 ? '0' : ''}${item.cartQuantity.toString()}',
            style: AppFontTextStyles.textStyleBold().copyWith(
              color: AppColors.primaryOrange,
              fontSize: Dimens.fontSizeEighteen,
            ),
          ),
        ),
        _AddRemoveButton(
          isAddButton: true,
          onTap: () => bloc.add(ChangeQuantityEvent(isAdding: true)),
        ),
      ],
    );
  }
}

class _AddRemoveButton extends StatelessWidget {
  final bool isAddButton;
  final Function()? onTap;

  const _AddRemoveButton({required this.isAddButton, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      backgroundColor: AppColors.primaryOrange,
      iconWidget: Icon(
        isAddButton ? Icons.add : Icons.remove,
        size: Dimens.iconMedium,
        color: AppColors.white,
      ),
      onTap: onTap,
    );
  }
}

class _CommonButton extends StatelessWidget {
  final bool isCart;
  final bool isSelected;
  final Function() onTap;

  const _CommonButton({
    required this.isCart,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      prefixWidget: AppSvgIcon(
        isCart ? Images.cart : Images.favorite,
        color: AppColors.white,
      ),
      backgroundColor:
          isSelected ? AppColors.primaryYellow : AppColors.primaryOrange,
      title:
          isCart
              ? isSelected
                  ? AppLocalization.currentLocalization().removeFromCart
                  : AppLocalization.currentLocalization().addToCart
              : isSelected
              ? AppLocalization.currentLocalization().removeFromFavorite
              : AppLocalization.currentLocalization().addToFavorite,
      onTap: onTap,
    );
  }
}
