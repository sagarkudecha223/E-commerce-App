import 'dart:math';

import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/routes.dart';
import '../../../model/item_model.dart';
import '../../../services/firebase/firebase_item_service.dart';
import '../../../services/order/order_service.dart';
import 'shop_contract.dart';

@injectable
class ShopBloc extends BaseBloc<ShopEvent, ShopData> {
  ShopBloc(this._orderService, this._firebaseItemService) : super(initState) {
    on<InitShopEvent>(_initShopEvent);
    on<TrackOrderTapEvent>(_trackOrderTapEvent);
    on<SliderChangeEvent>(_sliderChangeEvent);
    on<ItemTapEvent>(_itemTapEvent);
    on<UpdateShopState>((event, emit) => emit(event.state));
  }

  final OrderService _orderService;
  final FirebaseItemService _firebaseItemService;

  static ShopData get initState =>
      (ShopDataBuilder()
            ..state = ScreenState.loading
            ..sliderItems = []
            ..bestSellersItems = []
            ..recommendedItems = []
            ..sliderController = CarouselSliderController()
            ..currentSliderIndex = 0
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
                ..recommendedItems = _getRandomTenItems()
                ..bestSellersItems = _getRandomTenItems()
                ..sliderItems = _getRandomTenItems()
                ..lastOrder = isOrderAvailable ? order.first : null,
        ),
      ),
    );
  }

  void _sliderChangeEvent(SliderChangeEvent event, _) => add(
    UpdateShopState(state.rebuild((u) => u.currentSliderIndex = event.index)),
  );

  void _itemTapEvent(ItemTapEvent event, _) => dispatchViewEvent(
    NavigateScreen(
      AppRoutes.itemDetailScreen,
      data: {'item': event.item, 'tag': event.heroTag},
    ),
  );

  void _trackOrderTapEvent(_, __) {
    final locationString = state.lastOrder?.address.latLong ?? '';
    List<String> parts = locationString.split(',');

    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());

    LatLng latLng = LatLng(latitude, longitude);

    dispatchViewEvent(NavigateScreen(AppRoutes.trackOrderScreen, data: latLng));
  }

  List<ItemModel> _getRandomTenItems() {
    List<ItemModel> allItems = _firebaseItemService.allItemsList;
    final random = Random();
    final shuffled = List<ItemModel>.from(allItems)..shuffle(random);

    final count = shuffled.length >= 10 ? 10 : shuffled.length;

    return shuffled.take(count).toList();
  }
}
