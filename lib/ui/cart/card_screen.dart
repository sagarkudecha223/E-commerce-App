import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';

import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_contract.dart';
import '../common/skeleton/skeleton_cart_fav_list_view.dart';
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
            (_, __) => SingleChildScrollView(child: _MainContent(bloc: bloc)),
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
        return CartAndFavListView(itemList: bloc.state.cartItem);
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
