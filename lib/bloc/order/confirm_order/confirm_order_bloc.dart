import 'dart:async';

import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../../core/routes.dart';
import '../../../model/item_model.dart';
import '../../../services/firebase/address_service.dart';
import '../../../services/firebase/firebase_item_service.dart';
import '../../../services/payment/payment_service.dart';
import 'confirm_order_contract.dart';

@injectable
class ConfirmOrderBloc extends BaseBloc<ConfirmOrderEvent, ConfirmOrderData> {
  ConfirmOrderBloc(
    this._firebaseItemService,
    this._addressService,
    this._paymentService,
  ) : super(initState) {
    on<InitConfirmOrderEvent>(_initConfirmOrderEvent);
    on<AddAddressEvent>(_addAddressEvent);
    on<AddAddressChangeEvent>(_addAddressChangeEvent);
    on<PlaceOrderTapEvent>(_placeOrderTapEvent);
    on<UpdateConfirmOrderState>((event, emit) => emit(event.state));
    _observeNotifiers();
  }

  final FirebaseItemService _firebaseItemService;
  final AddressService _addressService;
  final PaymentService _paymentService;
  StreamSubscription? _itemStreamSub;
  StreamSubscription? _addressStreamSub;

  static ConfirmOrderData get initState =>
      (ConfirmOrderDataBuilder()
            ..state = ScreenState.loading
            ..totalPrice = 0
            ..itemList = []
            ..selectedAddress = null
            ..addressList = []
            ..isPaymentLoading = false
            ..errorMessage = '')
          .build();

  void _initConfirmOrderEvent(_, __) async {
    final addressList = await _addressService.fetchAddresses();
    add(
      UpdateConfirmOrderState(
        state.rebuild(
          (u) =>
              u
                ..itemList = _firebaseItemService.cartList
                ..totalPrice = _cartTotalPrice(
                  items: _firebaseItemService.cartList,
                )
                ..state = ScreenState.content
                ..selectedAddress =
                    addressList.isEmpty ? null : addressList.first,
        ),
      ),
    );
  }

  void _addAddressEvent(_, __) =>
      dispatchViewEvent(NavigateScreen(AppRoutes.addressScreen));

  void _placeOrderTapEvent(PlaceOrderTapEvent event, __) async {
    add(
      UpdateConfirmOrderState(state.rebuild((u) => u..isPaymentLoading = true)),
    );

    final data = await _paymentService.makePayment(
      amount: state.totalPrice.toInt(),
    );
    if (data is bool) {
      _displayMessage(message: 'Payment Success');
    } else {
      _displayMessage(message: 'Payment Failed');
    }
    add(
      UpdateConfirmOrderState(
        state.rebuild((u) => u..isPaymentLoading = false),
      ),
    );
  }

  void _addAddressChangeEvent(AddAddressChangeEvent event, __) => add(
    UpdateConfirmOrderState(
      state.rebuild((u) => u..selectedAddress = event.address),
    ),
  );

  _observeNotifiers() {
    _itemStreamSub = _firebaseItemService.cartStream.listen(
      (event) {
        List<ItemModel> list = [];
        list = event;
        add(
          UpdateConfirmOrderState(
            state.rebuild(
              (u) =>
                  u
                    ..itemList = list
                    ..totalPrice = _cartTotalPrice(items: list)
                    ..state = ScreenState.content,
            ),
          ),
        );
      },
      onError:
          (e) => add(
            UpdateConfirmOrderState(
              state.rebuild((u) => u.state = ScreenState.error),
            ),
          ),
    );

    _addressStreamSub = _addressService.addressStream.listen(
      (event) => add(
        UpdateConfirmOrderState(state.rebuild((u) => u.addressList = event)),
      ),
    );
  }

  num _cartTotalPrice({required List<ItemModel> items}) =>
      items.fold<num>(
        0,
        (sum, item) => sum + (item.price * item.cartQuantity),
      ) +
      35;

  _displayMessage({required String message}) {
    dispatchViewEvent(
      DisplayMessage(type: DisplayMessageType.toast, message: message),
    );
  }

  @override
  Future<void> close() {
    _itemStreamSub?.cancel();
    _addressStreamSub?.cancel();
    return super.close();
  }
}
