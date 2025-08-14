import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import '../../../bloc/shop/explore/explore_bloc.dart';
import '../../../bloc/shop/explore/explore_contract.dart';
import '../../common/app_loader.dart';
import '../../full_screen_error/full_screen_error.dart';
import '../food_menu/food_menu_view.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends BaseState<ExploreBloc, ExploreScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitExploreEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExploreBloc>(
      create: (_) => bloc,
      child: BlocBuilder<ExploreBloc, ExploreData>(
        builder: (_, __) => _MainContent(bloc: bloc),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final ExploreBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _ExploreContent(bloc: bloc);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap: () {},
        );
    }
  }
}

class _ExploreContent extends StatelessWidget {
  final ExploreBloc bloc;

  const _ExploreContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(children: [FoodMenuView(viewOnly: false)]);
  }
}
