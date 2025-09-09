import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../../model/item_model.dart';

part 'item_detail_contract.g.dart';

abstract class ItemDetailData
    implements Built<ItemDetailData, ItemDetailDataBuilder> {
  factory ItemDetailData([void Function(ItemDetailDataBuilder) updates]) =
      _$ItemDetailData;

  ItemDetailData._();

  ScreenState get state;

  ItemModel? get item;

  num get totalPrice;

  String? get errorMessage;
}

abstract class ItemDetailEvent {}

class InitItemDetailEvent extends ItemDetailEvent {
  final ItemModel item;

  InitItemDetailEvent({required this.item});
}

class AddToCardEvent extends ItemDetailEvent {}

class AddToFavoriteEvent extends ItemDetailEvent {}

class ChangeQuantityEvent extends ItemDetailEvent {
  final bool isAdding;

  ChangeQuantityEvent({required this.isAdding});
}

class UpdateItemDetailState extends ItemDetailEvent {
  final ItemDetailData state;

  UpdateItemDetailState(this.state);
}
