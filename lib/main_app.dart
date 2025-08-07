import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/localization_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'bloc/main_app/main_app_bloc.dart';
import 'bloc/main_app/main_app_contract.dart';
import 'core/colors.dart';
import 'core/constants.dart';
import 'core/styles.dart';
import 'injector/injection.dart';
import 'services/theme_service/app_theme.dart';
import 'services/theme_service/theme_service.dart';

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
  void onViewEvent(ViewAction event) {
    switch (event.runtimeType) {
      case const (ChangeTheme):
        _forceRebuildWidgets();
    }
  }

  void _forceRebuildWidgets() {
    void rebuild(Element widget) {
      widget.markNeedsBuild();
      widget.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: AppColors.isLightTheme ? ThemeMode.light : ThemeMode.dark,
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
        return Scaffold(
          body: Container(
            color: AppColors.backgroundColor,
            child: Center(
              child: InkWell(
                onTap: () => getIt.get<ThemeService>().changeThemeMode(),
                child: Text(
                  'Change Theme',
                  style: AppFontTextStyles.textStyleMedium(),
                ),
              ),
            ),
          ),
        );
      default:
        return Center(child: CircularProgressIndicator());
    }
  }
}
