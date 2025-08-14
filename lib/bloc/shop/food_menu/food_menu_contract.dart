import 'package:built_value/built_value.dart';
import '../../../core/enum.dart';

part 'food_menu_contract.g.dart';

abstract class FoodMenuData
    implements Built<FoodMenuData, FoodMenuDataBuilder> {
  factory FoodMenuData([void Function(FoodMenuDataBuilder) updates]) =
      _$FoodMenuData;

  FoodMenuData._();

  FoodMenuOptions get foodMenu;
}

abstract class FoodMenuEvent {}

class UpdateFoodMenuState extends FoodMenuEvent {
  final FoodMenuData state;

  UpdateFoodMenuState(this.state);
}
