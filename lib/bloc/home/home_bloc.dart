import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../core/enum.dart';
import '../../core/routes.dart';
import '../../services/firebase/auth_service.dart';
import '../../services/firebase/firebase_item_service.dart';
import '../../services/notifiers/notifiers.dart';
import '../../services/user/user_service.dart';
import 'home_contract.dart';

@injectable
class HomeBloc extends BaseBloc<HomeEvent, HomeData> {
  HomeBloc(
    this._userService,
    this._valueNotifiers,
    this._firebaseItemService,
    this._firebaseAuthService,
  ) : super(initState) {
    on<InitHomeEvent>(_initHomeEvent);
    on<CartTapEvent>(_cartTapEvent);
    on<OrderTapEvent>(_orderTapEvent);
    on<BottomItemTapEvent>(_bottomItemTapEvent);
    on<DrawerOptionTapEvent>(_drawerOptionTapEvent);
    on<UpdateHomeState>((event, emit) => emit(event.state));
    _observeNotifiers();
  }

  final UserService _userService;
  final ValueNotifiers _valueNotifiers;
  final FirebaseItemService _firebaseItemService;
  final FirebaseAuthService _firebaseAuthService;

  static HomeData get initState =>
      (HomeDataBuilder()
            ..state = ScreenState.loading
            ..currentIndex = 0
            ..errorMessage = '')
          .build();

  void _initHomeEvent(_, __) async {
    final userData = await _userService.getUser();
    await _firebaseItemService.init();
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

  void _cartTapEvent(_, __) =>
      dispatchViewEvent(NavigateScreen(AppRoutes.confirmOrderScreen));

  void _orderTapEvent(_, __) =>
      dispatchViewEvent(NavigateScreen(AppRoutes.myOrderScreen));

  void _drawerOptionTapEvent(DrawerOptionTapEvent event, _) async {
    switch (event.drawerOption) {
      case DrawerOptions.profile:
        dispatchViewEvent(NavigateScreen(AppRoutes.profileScreen));
      case DrawerOptions.myOrders:
        dispatchViewEvent(NavigateScreen(AppRoutes.myOrderScreen));
      case DrawerOptions.deliveryAddress:
        dispatchViewEvent(NavigateScreen(AppRoutes.addressScreen));
      case DrawerOptions.contactUs:
      case DrawerOptions.settings:
        dispatchViewEvent(NavigateScreen(AppRoutes.settingScreen));
      case DrawerOptions.logout:
        await _firebaseAuthService.signOut();
        dispatchViewEvent(NavigateScreen(AppRoutes.loginScreen));
    }
  }

  _observeNotifiers() {
    if (state.currentIndex == 0) {
      _valueNotifiers.foodMenuStream.listen(
        (event) => add(
          BottomItemTapEvent(index: BottomNavigationOptions.explore.index),
        ),
      );
    }
  }
}
