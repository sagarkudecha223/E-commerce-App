import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../../services/firebase/firebase_item_service.dart';
import 'item_card_contract.dart';

@injectable
class ItemCardBloc extends BaseBloc<ItemCardEvent, ItemCardData> {
  ItemCardBloc(this._firebaseItemService) : super(initState) {
    on<InitItemCardEvent>(_initItemCardEvent);
    on<AddToCardEvent>(_addToCardEvent);
    on<AddToFavoriteEvent>(_addToFavoriteEvent);
    on<UpdateItemCardState>((event, emit) => emit(event.state));
  }

  final FirebaseItemService _firebaseItemService;

  static ItemCardData get initState =>
      (ItemCardDataBuilder()
            ..state = ScreenState.loading
            ..errorMessage = '')
          .build();

  void _initItemCardEvent(InitItemCardEvent event, __) => add(
    UpdateItemCardState(
      state.rebuild(
        (u) =>
            u
              ..state = ScreenState.content
              ..item = event.item,
      ),
    ),
  );

  void _addToCardEvent(_, __) => _firebaseItemService.toggleCart(state.item!);

  void _addToFavoriteEvent(_, __) =>
      _firebaseItemService.toggleFavorite(state.item!);
}
