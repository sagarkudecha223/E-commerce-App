import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_contract.dart';
import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/enum.dart';
import '../../core/enum_extensions.dart';
import '../../core/images.dart';
import '../../core/styles.dart';
import '../../localization/app_localization.dart';
import '../cart/card_screen.dart';
import '../common/app_loader.dart';
import '../common/buttons/icon_button.dart';
import '../common/svg_icon.dart';
import '../decoration/screen_background.dart';
import '../favorite/favorite_screen.dart';
import '../full_screen_error/full_screen_error.dart';
import '../shop/explore/explore_screen.dart';
import '../shop/food_menu/food_menu_view.dart';
import '../shop/shop_screen.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeBloc, HomeScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      endDrawer: DrawerContent(bloc: bloc),
      body: SafeArea(
        child: BlocProvider<HomeBloc>(
          create: (_) => bloc,
          child: BlocBuilder<HomeBloc, HomeData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _HomeContent(bloc: bloc);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap: () {},
        );
    }
  }
}

class _HomeContent extends StatelessWidget {
  final HomeBloc bloc;

  const _HomeContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _AppBar(bloc: bloc),
        Expanded(
          child: Container(
            decoration: ScreenBackground(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Gap(Dimens.spaceSmall),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder:
                      (child, animation) => ClipRect(
                        child: SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.vertical,
                          axisAlignment: -1.0,
                          child: child,
                        ),
                      ),
                  child:
                      (bloc.state.currentIndex == 0 ||
                              bloc.state.currentIndex == 1)
                          ? FoodMenuView(
                            viewOnly: bloc.state.currentIndex == 0,
                            key: const ValueKey('menu'),
                          )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimens.space4xSmall,
                      horizontal: Dimens.space2xSmall,
                    ),
                    child: _CenterContent(index: bloc.state.currentIndex),
                  ),
                ),
                _BottomBar(bloc: bloc),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  final HomeBloc bloc;

  const _AppBar({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.space3xSmall,
        horizontal: Dimens.space4xLarge,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${AppLocalization.currentLocalization().welcome}, ${bloc.state.userData?.name}',
              style: AppFontTextStyles.appbarTextStyle(),
            ),
          ),
          AppIconButton(
            svgImage: Images.cart,
            onTap: () {},
            backgroundColor: AppColors.white,
          ),
          AppIconButton(
            svgImage: Images.profile,
            onTap: () {},
            backgroundColor: AppColors.white,
          ),
          AppIconButton(
            svgImage: Images.backArrow,
            onTap: () => Scaffold.of(context).openEndDrawer(),
            backgroundColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}

class _CenterContent extends StatelessWidget {
  final int index;

  const _CenterContent({required this.index});

  @override
  Widget build(BuildContext context) {
    return LazyLoadIndexedStack(
      index: index,
      preloadIndexes: [0],
      children: [
        const ShopScreen(),
        const ExploreScreen(),
        const CartScreen(),
        const FavoriteScreen(),
        const SizedBox(),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final HomeBloc bloc;

  const _BottomBar({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ScreenBackground(backgroundColor: AppColors.primaryOrange),
      child: Row(
        children:
            BottomNavigationOptions.values
                .map(
                  (item) => _IconButton(
                    onTap:
                        (option) => bloc.add(BottomItemTapEvent(index: option)),
                    isSelected: item.index == bloc.state.currentIndex,
                    item: item,
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final BottomNavigationOptions item;
  final Function(int option) onTap;
  final bool isSelected;

  const _IconButton({
    required this.item,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppIconButton(
        borderRadius: Dimens.radius4xLarge,
        onTap: () => onTap(item.index),
        iconWidget: Column(
          children: [
            AppSvgIcon(
              item.icon,
              color: AppColors.white,
              height: Dimens.iconMedium,
            ).animate(
              effects:
                  isSelected
                      ? [SlideEffect(begin: Offset(0, 0.2), end: Offset(0, 0))]
                      : [],
            ),
            if (isSelected)
              Text(
                item.title,
                style: AppFontTextStyles.textStyleSmall().copyWith(
                  color: AppColors.white,
                ),
              ).animate(effects: [ScaleEffect(), SlideEffect()]),
          ],
        ),
      ),
    );
  }
}
