import 'package:bloc_base_architecture/extension/string_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../bloc/shop/item_card/item_card_bloc.dart';
import '../../../bloc/shop/item_card/item_card_contract.dart';
import '../../../core/colors.dart';
import '../../../core/dimens.dart';
import '../../../core/images.dart';
import '../../../core/styles.dart';
import '../../../model/item_model.dart';
import '../../common/app_loader.dart';
import '../../common/buttons/icon_button.dart';
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
    if(widget.item != oldWidget.item){
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
        return const AppLoader();
      case ScreenState.content:
        return _ItemView(item: bloc.state.item!);
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

class _ItemView extends StatelessWidget {
  final ItemModel item;

  const _ItemView({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimens.space2xSmall),
      decoration: ContainerDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.radiusLarge),
            child: CachedNetworkImage(
              imageUrl: convertDriveLinkToDirect(item.imageUrl),
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
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceSmall,vertical: Dimens.spaceMedium),
              height: Dimens.containerSmall,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name.capitalize(),
                        style: AppFontTextStyles.textStyleBold().copyWith(
                          color: AppColors.textColor,
                          fontSize: Dimens.fontSizeEighteen,
                        ),
                      ),
                      Text(
                        item.description.capitalize(),
                        style: AppFontTextStyles.textStyleSmall(),
                      ),
                    ],
                  ),
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
                      AppIconButton(
                        svgImage: Images.cart,
                        onTap: () {},
                        hasBorder: true,
                        backgroundColor:
                            item.isFavorite
                                ? AppColors.lightRed
                                : AppColors.transparent,
                        imageColor:
                            item.isFavorite
                                ? AppColors.white
                                : AppColors.primaryOrange,
                        imageWidth: Dimens.iconSmall,
                        imageHeight: Dimens.iconSmall,
                        borderRadius: Dimens.radius4xLarge,
                      ),
                      AppIconButton(
                        svgImage: Images.favorite,
                        onTap: () {},
                        hasBorder: true,
                        backgroundColor:
                            item.isInCart
                                ? AppColors.lightRed
                                : AppColors.transparent,
                        imageColor:
                            item.isInCart
                                ? AppColors.white
                                : AppColors.primaryOrange,
                        imageWidth: Dimens.iconSmall,
                        imageHeight: Dimens.iconSmall,
                        borderRadius: Dimens.radius4xLarge,
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

String convertDriveLinkToDirect(String originalUrl) {
  // Regex to extract the file ID from Google Drive URL
  final RegExp regExp = RegExp(r'd/([^/]+)');
  final match = regExp.firstMatch(originalUrl);

  if (match != null && match.groupCount >= 1) {
    final fileId = match.group(1);
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  } else {
    return originalUrl; // fallback if not matched
  }
}
