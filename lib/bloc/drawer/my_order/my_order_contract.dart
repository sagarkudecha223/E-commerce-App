import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../../model/order_model.dart';

part 'my_order_contract.g.dart';

abstract class MyOrderData implements Built<MyOrderData, MyOrderDataBuilder> {
  factory MyOrderData([void Function(MyOrderDataBuilder) updates]) =
      _$MyOrderData;

  MyOrderData._();

  ScreenState get state;

  List<OrderModel> get orderList;

  String? get errorMessage;
}

abstract class MyOrderEvent {}

class InitMyOrderEvent extends MyOrderEvent {}

class UpdateMyOrderState extends MyOrderEvent {
  final MyOrderData state;

  UpdateMyOrderState(this.state);
}
