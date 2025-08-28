import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../model/item_model.dart';
part 'favorite_contract.g.dart';

abstract class FavoriteData
    implements Built<FavoriteData, FavoriteDataBuilder> {
  factory FavoriteData([void Function(FavoriteDataBuilder) updates]) =
      _$FavoriteData;

  FavoriteData._();

  ScreenState get state;

  List<ItemModel> get favoriteItems;

  String? get errorMessage;
}

abstract class FavoriteEvent {}

class InitFavoriteEvent extends FavoriteEvent {}

class UpdateFavoriteState extends FavoriteEvent {
  final FavoriteData state;

  UpdateFavoriteState(this.state);
}
