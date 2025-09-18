import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../../model/address_model.dart';
import '../../../model/item_model.dart';

part 'confirm_order_contract.g.dart';

abstract class ConfirmOrderData
    implements Built<ConfirmOrderData, ConfirmOrderDataBuilder> {
  factory ConfirmOrderData([void Function(ConfirmOrderDataBuilder) updates]) =
      _$ConfirmOrderData;

  ConfirmOrderData._();

  ScreenState get state;

  List<ItemModel> get itemList;

  num get totalPrice;

  Address? get selectedAddress;

  List<Address> get addressList;

  String? get errorMessage;
}

abstract class ConfirmOrderEvent {}

class InitConfirmOrderEvent extends ConfirmOrderEvent {}

class AddAddressEvent extends ConfirmOrderEvent {}

class AddAddressChangeEvent extends ConfirmOrderEvent {
  final Address address;

  AddAddressChangeEvent({required this.address});
}

class PlaceOrderTapEvent extends ConfirmOrderEvent {}

class UpdateConfirmOrderState extends ConfirmOrderEvent {
  final ConfirmOrderData state;

  UpdateConfirmOrderState(this.state);
}
