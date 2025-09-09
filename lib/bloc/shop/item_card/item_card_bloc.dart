import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../../core/routes.dart';
import '../../../services/firebase/firebase_item_service.dart';
import 'item_card_contract.dart';

@injectable
class ItemCardBloc extends BaseBloc<ItemCardEvent, ItemCardData> {
  ItemCardBloc(this._firebaseItemService) : super(initState) {
    on<InitItemCardEvent>(_initItemCardEvent);
    on<AddToCardEvent>(_addToCardEvent);
    on<AddToFavoriteEvent>(_addToFavoriteEvent);
    on<CardTapEvent>(_cardTapEvent);
    on<ChangeQuantityEvent>(_changeQuantityEvent);
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
              ..itemIsFavOrCart = event.itemIsFavOrCart
              ..item = event.item,
      ),
    ),
  );

  void _cardTapEvent(_, __) => dispatchViewEvent(
    NavigateScreen(AppRoutes.itemDetailScreen, data: state.item),
  );

  void _addToCardEvent(_, __) => _firebaseItemService.toggleCart(state.item!);

  void _addToFavoriteEvent(_, __) =>
      _firebaseItemService.toggleFavorite(state.item!);

  void _changeQuantityEvent(ChangeQuantityEvent event, __) {
    final updatedItem = state.item!.copyWith(
      cartQuantity:
          event.isAdding
              ? state.item!.cartQuantity + 1
              : state.item!.cartQuantity - 1,
    );
    add(UpdateItemCardState(state.rebuild((u) => u.item = updatedItem)));
  }
}
