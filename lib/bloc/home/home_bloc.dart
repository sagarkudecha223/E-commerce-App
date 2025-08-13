import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';
import '../../core/enum.dart';
import '../../services/user/user_service.dart';
import 'home_contract.dart';

@injectable
class HomeBloc extends BaseBloc<HomeEvent, HomeData> {
  HomeBloc(this._userService) : super(initState) {
    on<InitHomeEvent>(_initHomeEvent);
    on<BottomItemTapEvent>(_bottomItemTapEvent);
    on<DrawerOptionTapEvent>(_drawerOptionTapEvent);
    on<UpdateHomeState>((event, emit) => emit(event.state));
  }

  final UserService _userService;

  static HomeData get initState =>
      (HomeDataBuilder()
            ..state = ScreenState.loading
            ..currentIndex = 0
            ..errorMessage = '')
          .build();

  void _initHomeEvent(_, __) async {
    final userData = await _userService.getUser();
    add(
      UpdateHomeState(
        state.rebuild(
          (u) =>
              u
                ..state = ScreenState.content
                ..userData = userData,
        ),
      ),
    );
  }

  void _bottomItemTapEvent(BottomItemTapEvent event, _) =>
      add(UpdateHomeState(state.rebuild((u) => u.currentIndex = event.index)));

  void _drawerOptionTapEvent(DrawerOptionTapEvent event, _) {
    switch (event.drawerOption) {
      case DrawerOptions.profile:
      case DrawerOptions.myOrders:
      case DrawerOptions.deliveryAddress:
      case DrawerOptions.contactUs:
      case DrawerOptions.settings:
      case DrawerOptions.logout:
    }
  }
}
