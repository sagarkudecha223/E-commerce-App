import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../../model/item_model.dart';

part 'item_card_contract.g.dart';

abstract class ItemCardData
    implements Built<ItemCardData, ItemCardDataBuilder> {
  factory ItemCardData([void Function(ItemCardDataBuilder) updates]) =
      _$ItemCardData;

  ItemCardData._();

  ScreenState get state;

  ItemModel? get item;

  String? get errorMessage;
}

abstract class ItemCardEvent {}

class InitItemCardEvent extends ItemCardEvent {
  final ItemModel item;

  InitItemCardEvent({required this.item});
}

class UpdateItemCardState extends ItemCardEvent {
  final ItemCardData state;

  UpdateItemCardState(this.state);
}
