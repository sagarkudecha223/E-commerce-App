import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import '../../bloc/favorite/favorite_bloc.dart';
import '../../bloc/favorite/favorite_contract.dart';
import '../../core/styles.dart';
import '../../localization/app_localization.dart';
import '../../model/item_model.dart';
import '../common/skeleton/skeleton_list_view.dart';
import '../full_screen_error/full_screen_error.dart';
import '../shop/item_card/item_card_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends BaseState<FavoriteBloc, FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitFavoriteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteBloc>(
      create: (_) => bloc,
      child: BlocBuilder<FavoriteBloc, FavoriteData>(
        builder: (_, __) => _MainContent(bloc: bloc),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final FavoriteBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const SkeletonListView();
      case ScreenState.content:
        return _FavoriteItemsView(itemList: bloc.state.favoriteItems);
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

class _FavoriteItemsView extends StatelessWidget {
  final List<ItemModel> itemList;

  const _FavoriteItemsView({required this.itemList});

  @override
  Widget build(BuildContext context) {
    return itemList.isNotEmpty
        ? ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, index) => ItemCardView(item: itemList[index]),
          shrinkWrap: true,
        )
        : Center(
          child: Text(
            AppLocalization.currentLocalization().yourFavoriteIsEmpty,
            style: AppFontTextStyles.textStyleBold(),
          ),
        );
  }
}
