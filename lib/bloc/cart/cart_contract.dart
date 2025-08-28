import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../model/item_model.dart';

part 'cart_contract.g.dart';

abstract class CartData implements Built<CartData, CartDataBuilder> {
  factory CartData([void Function(CartDataBuilder) updates]) = _$CartData;

  CartData._();

  ScreenState get state;

  List<ItemModel> get cartItem;

  num get totalPrice;

  String? get errorMessage;
}

abstract class CartEvent {}

class InitCartEvent extends CartEvent {}

class UpdateCartState extends CartEvent {
  final CartData state;

  UpdateCartState(this.state);
}
