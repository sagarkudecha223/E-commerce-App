import 'package:bloc_base_architecture/core/base_state.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import '../../../bloc/shop/food_menu/food_menu_bloc.dart';
import '../../../bloc/shop/food_menu/food_menu_contract.dart';
import '../../../core/colors.dart';
import '../../../core/dimens.dart';
import '../../../core/enum.dart';
import '../../../core/enum_extensions.dart';
import '../../../core/styles.dart';
import '../../../injector/injection.dart';
import '../../../services/notifiers/notifiers.dart';
import '../../common/buttons/icon_button.dart';
import '../../common/svg_icon.dart';
import '../../decoration/screen_background.dart';

class FoodMenuView extends StatefulWidget {
  final bool viewOnly;

  const FoodMenuView({super.key, required this.viewOnly});

  @override
  State<FoodMenuView> createState() => _FoodMenuViewState();
}

class _FoodMenuViewState extends BaseState<FoodMenuBloc, FoodMenuView>  with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final foodMenu = getIt.get<ValueNotifiers>().foodMenuStreamer;
    return BlocProvider<FoodMenuBloc>(
      create: (_) => bloc,
      child: BlocBuilder<FoodMenuBloc, FoodMenuData>(
        builder:
            (_, __) => StreamBuilder(
              stream: foodMenu.stream,
              builder:
                  (context, snapshot) => Container(
                    margin: EdgeInsets.only(top: Dimens.spaceSmall),
                    decoration: ScreenBackground(
                      backgroundColor: AppColors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.spaceLarge,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children:
                          FoodMenuOptions.values
                              .map(
                                (item) => _IconButton(
                                  onTap: () => foodMenu.add(item),
                                  isSelected:
                                      widget.viewOnly
                                          ? false
                                          : bloc.state.foodMenu == item,
                                  item: item,
                                ),
                              )
                              .toList(),
                    ),
                  ),
            ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final FoodMenuOptions item;
  final Function() onTap;
  final bool isSelected;

  const _IconButton({
    required this.item,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          begin: AppColors.white,
          end: isSelected ? AppColors.primaryOrange : AppColors.white,
        ),
        duration: isSelected ? Duration(milliseconds: 700) : Duration.zero,
        builder:
            (_, color, __) => AppIconButton(
              borderRadius: Dimens.radius4xLarge,
              backgroundColor: color,
              onTap: onTap,
              iconWidget: Column(
                children: [
                  AppSvgIcon(item.icon, height: Dimens.icon6xLarge),
                  Text(
                    item.title,
                    style: AppFontTextStyles.textStyleSmall().copyWith(
                      color: isSelected ? AppColors.white : AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
