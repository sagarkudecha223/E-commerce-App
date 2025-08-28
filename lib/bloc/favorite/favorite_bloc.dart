import 'dart:async';

import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../model/item_model.dart';
import '../../services/firebase/firebase_item_service.dart';
import 'favorite_contract.dart';

@injectable
class FavoriteBloc extends BaseBloc<FavoriteEvent, FavoriteData> {
  FavoriteBloc(this._firebaseItemService) : super(initState) {
    on<InitFavoriteEvent>(_initFavoriteEvent);
    on<UpdateFavoriteState>((event, emit) => emit(event.state));
    _observeNotifiers();
  }

  final FirebaseItemService _firebaseItemService;
  StreamSubscription? _itemStreamSub;

  static FavoriteData get initState =>
      (FavoriteDataBuilder()
            ..state = ScreenState.loading
            ..favoriteItems = []
            ..errorMessage = '')
          .build();

  void _initFavoriteEvent(_, __) => add(
    UpdateFavoriteState(
      state.rebuild(
        (u) =>
            u
              ..favoriteItems = _firebaseItemService.favoriteList
              ..state = ScreenState.content,
      ),
    ),
  );

  _observeNotifiers() =>
      _itemStreamSub = _firebaseItemService.favoritesStream.listen(
        (event) {
          List<ItemModel> list = [];
          list = event;
          add(
            UpdateFavoriteState(
              state.rebuild(
                (u) =>
                    u
                      ..favoriteItems = list
                      ..state = ScreenState.content,
              ),
            ),
          );
        },
        onError:
            (e) => add(
              UpdateFavoriteState(
                state.rebuild((u) => u.state = ScreenState.error),
              ),
            ),
      );

  @override
  Future<void> close() {
    _itemStreamSub?.cancel();
    return super.close();
  }
}
