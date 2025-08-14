import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../../core/enum.dart';

part 'explore_contract.g.dart';

abstract class ExploreData implements Built<ExploreData, ExploreDataBuilder> {
  factory ExploreData([void Function(ExploreDataBuilder) updates]) =
      _$ExploreData;

  ExploreData._();

  ScreenState get state;

  FoodMenuOptions get foodMenu;

  String? get errorMessage;
}

abstract class ExploreEvent {}

class InitExploreEvent extends ExploreEvent {}

class UpdateExploreState extends ExploreEvent {
  final ExploreData state;

  UpdateExploreState(this.state);
}
