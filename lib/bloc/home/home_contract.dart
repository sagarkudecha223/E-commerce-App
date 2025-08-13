import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../core/enum.dart';
import '../../model/user_model.dart';

part 'home_contract.g.dart';

abstract class HomeData implements Built<HomeData, HomeDataBuilder> {
  factory HomeData([void Function(HomeDataBuilder) updates]) = _$HomeData;

  HomeData._();

  ScreenState get state;

  int get currentIndex;

  UserModel? get userData;

  String? get errorMessage;
}

abstract class HomeEvent {}

class InitHomeEvent extends HomeEvent {}

class BottomItemTapEvent extends HomeEvent {
  final int index;

  BottomItemTapEvent({required this.index});
}

class DrawerOptionTapEvent extends HomeEvent {
  final DrawerOptions drawerOption;

  DrawerOptionTapEvent({required this.drawerOption});
}

class UpdateHomeState extends HomeEvent {
  final HomeData state;

  UpdateHomeState(this.state);
}
