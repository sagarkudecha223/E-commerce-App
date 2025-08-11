import 'package:bloc_base_architecture/api/network/network_info.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:injectable/injectable.dart';
import 'full_screen_error_contractor.dart';

@injectable
class FullScreenErrorBloc
    extends BaseBloc<FullScreenErrorEvent, FullScreenErrorData> {
  FullScreenErrorBloc(this._networkInfoImpl) : super(initState) {
    on<UpdateFullScreenErrorState>((event, emit) => emit(event.state));
    _observeNetworkChange();
  }

  final NetworkInfoImpl _networkInfoImpl;

  static FullScreenErrorData get initState =>
      (FullScreenErrorDataBuilder()..state = ScreenState.content).build();

  void _observeNetworkChange() {
    _networkInfoImpl.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) async {
      if (await _networkInfoImpl.isConnected) {
        dispatchViewEvent(
          NavigateScreen(FullScreenErrorTarget.NETWORK_RESTORED),
        );
      }
    });
  }
}
