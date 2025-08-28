import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../core/enum.dart';

@singleton
class ValueNotifiers {
  // final foodMenuStreamer = StreamController<FoodMenuOptions>.broadcast();

  final _foodMenuController = StreamController<FoodMenuOptions>.broadcast();
  FoodMenuOptions? _lastFoodMenu;

  Stream<FoodMenuOptions> get foodMenuStream => _foodMenuController.stream;

  FoodMenuOptions? get lastFoodMenu => _lastFoodMenu;

  void updateFoodMenu(FoodMenuOptions value) {
    _lastFoodMenu = value;
    _foodMenuController.add(value);
  }

  void dispose() => _foodMenuController.close();
}
