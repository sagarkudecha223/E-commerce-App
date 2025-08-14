import 'package:bloc_base_architecture/core/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/enum.dart';
import '../../../services/notifiers/notifiers.dart';
import 'food_menu_contract.dart';

@injectable
class FoodMenuBloc extends BaseBloc<FoodMenuEvent, FoodMenuData> {
  FoodMenuBloc(this._valueNotifiers) : super(initState) {
    on<UpdateFoodMenuState>((event, emit) => emit(event.state));
    _observeNotifiers();
  }

  final ValueNotifiers _valueNotifiers;
  static FoodMenuOptions? _foodMenuOptions;

  static FoodMenuData get initState =>
      (FoodMenuDataBuilder()
            ..foodMenu = _foodMenuOptions ?? FoodMenuOptions.snacks)
          .build();

  _observeNotifiers() {
    _valueNotifiers.foodMenuStreamer.stream.listen((event) {
      _foodMenuOptions = event;
      add(
        UpdateFoodMenuState(
          state.rebuild((u) => u.foodMenu = _foodMenuOptions),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _valueNotifiers.foodMenuStreamer.close();
    return super.close();
  }
}
