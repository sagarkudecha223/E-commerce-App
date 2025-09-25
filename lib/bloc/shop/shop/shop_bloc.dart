import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/routes.dart';
import '../../../services/order/order_service.dart';
import 'shop_contract.dart';

@injectable
class ShopBloc extends BaseBloc<ShopEvent, ShopData> {
  ShopBloc(this._orderService) : super(initState) {
    on<InitShopEvent>(_initShopEvent);
    on<TrackOrderTapEvent>(_trackOrderTapEvent);
    on<UpdateShopState>((event, emit) => emit(event.state));
  }

  final OrderService _orderService;

  static ShopData get initState =>
      (ShopDataBuilder()
            ..state = ScreenState.loading
            ..errorMessage = '')
          .build();

  void _initShopEvent(_, __) async {
    final order = await _orderService.fetchOrders();
    bool isOrderAvailable = false;
    if (order.isNotEmpty) {
      order.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      isOrderAvailable = order.first.status == 'pending';
    }
    add(
      UpdateShopState(
        state.rebuild(
          (u) =>
              u
                ..state = ScreenState.content
                ..lastOrder = isOrderAvailable ? order.first : null,
        ),
      ),
    );
  }

  void _trackOrderTapEvent(_, __) {
    final locationString = state.lastOrder?.address.latLong ?? '';
    List<String> parts = locationString.split(',');

    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());

    LatLng latLng = LatLng(latitude, longitude);

    dispatchViewEvent(NavigateScreen(AppRoutes.trackOrderScreen, data: latLng));
  }
}
