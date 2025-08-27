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

class _FoodMenuViewState extends BaseState<FoodMenuBloc, FoodMenuView> {
  @override
  Widget build(BuildContext context) {
    final foodMenu = getIt.get<ValueNotifiers>().foodMenuStreamer;
    return BlocProvider<FoodMenuBloc>(
      create: (_) => bloc,
      child: BlocBuilder<FoodMenuBloc, FoodMenuData>(
        builder:
            (_, __) => StreamBuilder(
              stream: foodMenu.stream,
              builder:
                  (context, snapshot) => Container(
                    decoration: ScreenBackground(),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.space2xSmall,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.space5xSmall),
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: AppColors.white,
            end:
                isSelected
                    ? AppColors.primaryOrange
                    : AppColors.backgroundColor,
          ),
          duration: isSelected ? Duration(milliseconds: 700) : Duration.zero,
          builder:
              (_, color, __) => AppIconButton(
                borderRadius: Dimens.radius4xLarge,
                backgroundColor: color,
                hasBorder: true,
                onTap: onTap,
                iconWidget: Column(
                  children: [
                    AppSvgIcon(item.icon, height: Dimens.icon6xLarge),
                    Text(
                      item.title,
                      style: AppFontTextStyles.textStyleSmall().copyWith(
                        color:
                            isSelected ? AppColors.white : AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
