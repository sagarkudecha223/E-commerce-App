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

  const CartAndFavListView({super.key, required this.itemList});

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
              (context, index) => CardAndFavItemView(item: itemList[index]),
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
