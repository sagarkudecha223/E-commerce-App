import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_contract.dart';
import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../core/styles.dart';
import '../../localization/app_localization.dart';
import '../common/buttons/elevated_button.dart';
import '../common/skeleton/skeleton_cart_fav_list_view.dart';
import '../decoration/screen_background.dart';
import '../full_screen_error/full_screen_error.dart';
import '../shop/item_card/cart_and_fav/cart_and_fav_list_view.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends BaseState<CartBloc, CartScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (_) => bloc,
      child: BlocBuilder<CartBloc, CartData>(
        builder:
            (_, __) => Stack(
              children: [
                SingleChildScrollView(child: _MainContent(bloc: bloc)),
                if (bloc.state.totalPrice != 0)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _PriceInfo(bloc: bloc),
                  ),
              ],
            ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final CartBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const SkeletonCartFavListView();
      case ScreenState.content:
        return CartAndFavListView(
          itemList: bloc.state.cartItem,
          isFavList: false,
        );
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

class _PriceInfo extends StatelessWidget {
  final CartBloc bloc;

  const _PriceInfo({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ScreenBackground(),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceSmall),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              '${AppLocalization.currentLocalization().total} : ${bloc.state.totalPrice}',
              style: AppFontTextStyles.textStyleBold().copyWith(
                color: AppColors.textColor,
              ),
            ),
          ),
          Expanded(
            child: AppElevatedButton(
              title: AppLocalization.currentLocalization().checkOut,
              suffixWidget: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
