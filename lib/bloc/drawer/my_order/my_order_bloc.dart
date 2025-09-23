import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../../services/order/order_service.dart';
import 'my_order_contract.dart';

@injectable
class MyOrderBloc extends BaseBloc<MyOrderEvent, MyOrderData> {
  MyOrderBloc(this._orderService) : super(initState) {
    on<InitMyOrderEvent>(_initMyOrderEvent);
    on<UpdateMyOrderState>((event, emit) => emit(event.state));
  }

  final OrderService _orderService;

  static MyOrderData get initState =>
      (MyOrderDataBuilder()
            ..state = ScreenState.loading
            ..orderList = []
            ..errorMessage = '')
          .build();

  void _initMyOrderEvent(_, __) async {
    final orderList = await _orderService.fetchOrders();
    add(
      UpdateMyOrderState(
        state.rebuild(
          (u) =>
              u
                ..state = ScreenState.content
                ..orderList = orderList,
        ),
      ),
    );
  }
}
