import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../../model/item_model.dart';
import '../../../services/firebase/firebase_item_service.dart';
import 'item_detail_contract.dart';

@injectable
class ItemDetailBloc extends BaseBloc<ItemDetailEvent, ItemDetailData> {
  ItemDetailBloc(this._firebaseItemService) : super(initState) {
    on<InitItemDetailEvent>(_initItemDetailEvent);
    on<AddToCardEvent>(_addToCardEvent);
    on<AddToFavoriteEvent>(_addToFavoriteEvent);
    on<ChangeQuantityEvent>(_changeQuantityEvent);
    on<UpdateItemDetailState>((event, emit) => emit(event.state));
  }

  final FirebaseItemService _firebaseItemService;

  static ItemDetailData get initState =>
      (ItemDetailDataBuilder()
            ..state = ScreenState.loading
            ..heroTag = ''
            ..totalPrice = 0
            ..errorMessage = '')
          .build();

  void _initItemDetailEvent(InitItemDetailEvent event, _) => add(
    UpdateItemDetailState(
      state.rebuild(
        (u) =>
            u
              ..state = ScreenState.content
              ..totalPrice = 0
              ..heroTag = event.heroTag
              ..item = event.item,
      ),
    ),
  );

  void _addToCardEvent(_, __) {
    final quantity =
        state.item!.cartQuantity == 0 ? 1 : state.item!.cartQuantity;
    _firebaseItemService.toggleCart(
      state.item!.copyWith(cartQuantity: quantity),
    );
    final updatedItem = state.item!.copyWith(
      isInCart: !state.item!.isInCart,
      cartQuantity: quantity,
    );
    _updateItem(updatedItem: updatedItem);
  }

  void _addToFavoriteEvent(_, __) {
    _firebaseItemService.toggleFavorite(state.item!);
    final updatedItem = state.item!.copyWith(
      isFavorite: !state.item!.isFavorite,
    );
    _updateItem(updatedItem: updatedItem);
  }

  void _changeQuantityEvent(ChangeQuantityEvent event, __) {
    final updatedItem = state.item!.copyWith(
      cartQuantity:
          event.isAdding
              ? state.item!.cartQuantity + 1
              : state.item!.cartQuantity - 1,
    );
    _updateItem(updatedItem: updatedItem);
  }

  _updateItem({required ItemModel updatedItem}) =>
      add(UpdateItemDetailState(state.rebuild((u) => u.item = updatedItem)));
}
