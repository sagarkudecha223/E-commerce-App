import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';
import '../../../core/enum.dart';
import 'explore_contract.dart';

@injectable
class ExploreBloc extends BaseBloc<ExploreEvent, ExploreData> {
  ExploreBloc() : super(initState) {
    on<InitExploreEvent>(_initExploreEvent);
    on<UpdateExploreState>((event, emit) => emit(event.state));
  }

  static ExploreData get initState =>
      (ExploreDataBuilder()
            ..state = ScreenState.loading
            ..foodMenu = FoodMenuOptions.snacks
            ..errorMessage = '')
          .build();

  void _initExploreEvent(_, __) {
    add(
      UpdateExploreState(state.rebuild((u) => u..state = ScreenState.content)),
    );
  }
}
