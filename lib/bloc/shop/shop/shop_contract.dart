import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:built_value/built_value.dart';

import '../../../model/order_model.dart';

part 'shop_contract.g.dart';

abstract class ShopData implements Built<ShopData, ShopDataBuilder> {
  factory ShopData([void Function(ShopDataBuilder) updates]) = _$ShopData;

  ShopData._();

  ScreenState get state;

  OrderModel? get lastOrder;

  String? get errorMessage;
}

abstract class ShopEvent {}

class InitShopEvent extends ShopEvent {}

class TrackOrderTapEvent extends ShopEvent {}

class UpdateShopState extends ShopEvent {
  final ShopData state;

  UpdateShopState(this.state);
}
