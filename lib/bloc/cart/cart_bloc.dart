import 'dart:async';

import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../core/routes.dart';
import '../../model/item_model.dart';
import '../../services/firebase/firebase_item_service.dart';
import 'cart_contract.dart';

@injectable
class CartBloc extends BaseBloc<CartEvent, CartData> {
  CartBloc(this._firebaseItemService) : super(initState) {
    on<InitCartEvent>(_initCartEvent);
    on<CheckTapEvent>(_checkTapEvent);
    on<UpdateCartState>((event, emit) => emit(event.state));
    _observeNotifiers();
  }

  final FirebaseItemService _firebaseItemService;
  StreamSubscription? _itemStreamSub;

  static CartData get initState =>
      (CartDataBuilder()
            ..state = ScreenState.loading
            ..totalPrice = 0
            ..cartItem = []
            ..errorMessage = '')
          .build();

  void _initCartEvent(_, __) => add(
    UpdateCartState(
      state.rebuild(
        (u) =>
            u
              ..cartItem = _firebaseItemService.cartList
              ..totalPrice = _cartTotalPrice(
                items: _firebaseItemService.cartList,
              )
              ..state = ScreenState.content,
      ),
    ),
  );

  _observeNotifiers() =>
      _itemStreamSub = _firebaseItemService.cartStream.listen(
        (event) {
          List<ItemModel> list = [];
          list = event;
          add(
            UpdateCartState(
              state.rebuild(
                (u) =>
                    u
                      ..cartItem = list
                      ..totalPrice = _cartTotalPrice(items: list)
                      ..state = ScreenState.content,
              ),
            ),
          );
        },
        onError:
            (e) => add(
              UpdateCartState(
                state.rebuild((u) => u.state = ScreenState.error),
              ),
            ),
      );

  num _cartTotalPrice({required List<ItemModel> items}) =>
      items.fold<num>(0, (sum, item) => sum + (item.price * item.cartQuantity));

  void _checkTapEvent(_, __) =>
      dispatchViewEvent(NavigateScreen(AppRoutes.confirmOrderScreen));

  @override
  Future<void> close() {
    _itemStreamSub?.cancel();
    return super.close();
  }
}
