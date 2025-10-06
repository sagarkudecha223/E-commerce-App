import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/routes.dart';
import '../../../services/order/order_service.dart';
import 'my_order_contract.dart';

@injectable
class MyOrderBloc extends BaseBloc<MyOrderEvent, MyOrderData> {
  MyOrderBloc(this._orderService) : super(initState) {
    on<InitMyOrderEvent>(_initMyOrderEvent);
    on<TrackOrderTapEvent>(_trackOrderTapEvent);
    on<CancelOrderTapEvent>(_cancelOrderTapEvent);
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

  void _trackOrderTapEvent(TrackOrderTapEvent event, _) {
    final locationString = event.orderModel.address.latLong;
    List<String> parts = locationString.split(',');

    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());

    LatLng latLng = LatLng(latitude, longitude);

    dispatchViewEvent(NavigateScreen(AppRoutes.trackOrderScreen, data: latLng));
  }

  void _cancelOrderTapEvent(CancelOrderTapEvent event, _) async {
    add(
      UpdateMyOrderState(state.rebuild((u) => u.state = ScreenState.loading)),
    );
    await _orderService.deleteOrder(event.orderModel.id);
    add(InitMyOrderEvent());
  }
}
