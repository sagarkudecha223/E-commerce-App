import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../core/dimens.dart';
import '../../../../core/enum.dart';
import '../../../../core/images.dart';
import '../../../../core/styles.dart';
import '../../../../injector/injection.dart';
import '../../../../localization/app_localization.dart';
import '../../../../model/item_model.dart';
import '../../../../services/notifiers/notifiers.dart';
import '../../../common/buttons/icon_button.dart';
import 'cart_and_fav_card_view.dart';

class CartAndFavListView extends StatelessWidget {
  final List<ItemModel> itemList;
  final bool isFavList;
  const CartAndFavListView({super.key, required this.itemList, required this.isFavList});

  @override
  Widget build(BuildContext context) {
    return itemList.isNotEmpty
        ? GridView.builder(
          padding: const EdgeInsets.all(Dimens.space3xSmall),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: Dimens.containerXMedium,
            mainAxisExtent: 280,
            crossAxisSpacing: Dimens.spaceXSmall,
            mainAxisSpacing: Dimens.spaceXSmall,
          ),
          itemCount: itemList.length,
          itemBuilder:
              (context, index) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, animation) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  );
                  return FadeTransition(
                    opacity: curved,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.90,
                        end: 1.0,
                      ).animate(curved),
                      child: child,
                    ),
                  );
                },
                child: CardAndFavItemView(
                  item: itemList[index],
                  key: ValueKey(itemList[index].id),
                  itemIsFav: isFavList,
                ),
              ),
          shrinkWrap: true,
        )
        : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIconButton(
                svgImage: Images.dish,
                onTap:
                    () => getIt.get<ValueNotifiers>().updateFoodMenu(
                      FoodMenuOptions.snacks,
                    ),
                hasBorder: true,
              ),
              Text(
                AppLocalization.currentLocalization().wantToAddSomething,
                style: AppFontTextStyles.textStyleBold().copyWith(
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
        );
  }
}
