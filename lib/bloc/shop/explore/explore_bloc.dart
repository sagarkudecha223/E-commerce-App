import 'dart:async';

import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';
import '../../../core/enum.dart';
import '../../../model/item_model.dart';
import '../../../services/firebase/firebase_item_service.dart';
import '../../../services/notifiers/notifiers.dart';
import 'explore_contract.dart';

@injectable
class ExploreBloc extends BaseBloc<ExploreEvent, ExploreData> {
  ExploreBloc(this._firebaseItemService, this._valueNotifiers)
    : super(initState) {
    on<InitExploreEvent>(_initExploreEvent);
    on<UpdateExploreState>((event, emit) => emit(event.state));
    _observeNotifiers();
  }

  final FirebaseItemService _firebaseItemService;
  final ValueNotifiers _valueNotifiers;
  static FoodMenuOptions? _foodMenuOptions;
  StreamSubscription? _itemStreamSub;

  static ExploreData get initState =>
      (ExploreDataBuilder()
            ..state = ScreenState.loading
            ..foodMenu = FoodMenuOptions.snacks
            ..allItems = []
            ..errorMessage = '')
          .build();

  void _initExploreEvent(_, __) async {
    await _firebaseItemService.init();
    add(
      UpdateExploreState(
        state.rebuild(
          (u) =>
              u
                ..foodMenu = _foodMenuOptions ?? FoodMenuOptions.snacks,
        ),
      ),
    );
  }

  List<ItemModel> itemsByCategory(FoodMenuOptions category) =>
      state.allItems.where((item) => item.categoryId == category.name).toList();

  _observeNotifiers() {
    _valueNotifiers.foodMenuStreamer.stream.listen((event) {
      _foodMenuOptions = event;
      add(
        UpdateExploreState(state.rebuild((u) => u.foodMenu = _foodMenuOptions)),
      );
    });
    _itemStreamSub = _firebaseItemService.itemsStream.listen(
      (event) {
        List<ItemModel> list = [];
        list = event;
        add(UpdateExploreState(state.rebuild((u) => u..allItems = list
          ..state = ScreenState.content)));
      },
      onError:
          (e) => add(
            UpdateExploreState(
              state.rebuild((u) => u.state = ScreenState.error),
            ),
          ),
    );
  }

  @override
  Future<void> close() {
    _itemStreamSub?.cancel();
    return super.close();
  }
}
