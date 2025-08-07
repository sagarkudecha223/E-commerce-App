import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'bloc/main_app/main_app_bloc.dart';
import 'bloc/main_app/main_app_contract.dart';
import 'core/colors.dart';
import 'core/constants.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends BaseState<MainAppBloc, MainAppScreen> {
  @override
  void initState() {
    super.initState();
    navigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: BlocProvider<MainAppBloc>(
            create: (_) => bloc,
            child: BlocBuilder<MainAppBloc, MainAppData>(
              builder: (_, __) => _MainContent(bloc: bloc),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final MainAppBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return Center(child: CircularProgressIndicator());
      case ScreenState.content:
        return Container();
      default:
        return Center(child: CircularProgressIndicator());
    }
  }
}
