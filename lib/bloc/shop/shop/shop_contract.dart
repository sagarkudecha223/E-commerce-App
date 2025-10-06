import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:built_value/built_value.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../model/item_model.dart';
import '../../../model/order_model.dart';

part 'shop_contract.g.dart';

abstract class ShopData implements Built<ShopData, ShopDataBuilder> {
  factory ShopData([void Function(ShopDataBuilder) updates]) = _$ShopData;

  ShopData._();

  ScreenState get state;

  OrderModel? get lastOrder;

  List<ItemModel> get sliderItems;

  List<ItemModel> get bestSellersItems;

  List<ItemModel> get recommendedItems;

  int get currentSliderIndex;

  CarouselSliderController get sliderController;

  String? get errorMessage;
}

abstract class ShopEvent {}

class InitShopEvent extends ShopEvent {}

class TrackOrderTapEvent extends ShopEvent {}

class ItemTapEvent extends ShopEvent {
  final ItemModel item;
  final String heroTag;

  ItemTapEvent({required this.item,required this.heroTag});
}

class SliderChangeEvent extends ShopEvent {
  final int index;

  SliderChangeEvent({required this.index});
}

class UpdateShopState extends ShopEvent {
  final ShopData state;

  UpdateShopState(this.state);
}
