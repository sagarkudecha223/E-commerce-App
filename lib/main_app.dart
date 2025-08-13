import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/localization_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'bloc/main_app/main_app_bloc.dart';
import 'bloc/main_app/main_app_contract.dart';
import 'core/constants.dart';
import 'injector/injection.dart';
import 'services/theme_service/app_theme.dart';
import 'services/theme_service/theme_service.dart';
import 'ui/home/home_screen.dart';
import 'ui/login/login_screen.dart';

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
    bloc.add(InitMainAppEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: getIt.get<ThemeService>().themeNotifier,
      builder:
          (_, themeMode, __) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
            navigatorKey: navigatorKey,
            supportedLocales: AppConstant.localizationList.toLocaleList(),
            home: BlocProvider<MainAppBloc>(
              create: (_) => bloc,
              child: BlocBuilder<MainAppBloc, MainAppData>(
                builder: (_, __) => _MainContent(bloc: bloc),
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
      case ScreenState.content:
        return bloc.state.isLoggedIn ? HomeScreen() : LoginScreen();
      default:
        return Center(child: CircularProgressIndicator());
    }
  }
}
