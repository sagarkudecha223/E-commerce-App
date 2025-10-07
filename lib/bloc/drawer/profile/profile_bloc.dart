import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';

import '../../../services/firebase/address_service.dart';
import '../../../services/user/user_service.dart';
import 'profile_contract.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileData> {
  ProfileBloc(this._userService, this._addressService) : super(initState) {
    on<InitProfileEvent>(_initProfileEvent);
    on<UpdateProfileState>((event, emit) => emit(event.state));
  }

  final UserService _userService;
  final AddressService _addressService;

  static ProfileData get initState =>
      (ProfileDataBuilder()
            ..state = ScreenState.loading
            ..errorMessage = '')
          .build();

  void _initProfileEvent(_, __) async {
    final userData = await _userService.getUser();
    final addressList = await _addressService.fetchAddresses();
    add(
      UpdateProfileState(
        state.rebuild(
          (u) =>
              u
                ..userdata = userData
                ..addressList = addressList
                ..state = ScreenState.content,
        ),
      ),
    );
  }
}
