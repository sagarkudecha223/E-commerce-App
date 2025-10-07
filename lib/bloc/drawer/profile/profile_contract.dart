import 'package:bloc_base_architecture/core/screen_state.dart';
import 'package:built_value/built_value.dart';

import '../../../model/address_model.dart';
import '../../../model/user_model.dart';

part 'profile_contract.g.dart';

abstract class ProfileData implements Built<ProfileData, ProfileDataBuilder> {
  factory ProfileData([void Function(ProfileDataBuilder) updates]) =
      _$ProfileData;

  ProfileData._();

  ScreenState get state;

  UserModel? get userdata;

  List<Address>? get addressList;

  String? get errorMessage;
}

abstract class ProfileEvent {}

class InitProfileEvent extends ProfileEvent {}

class UpdateProfileState extends ProfileEvent {
  final ProfileData state;

  UpdateProfileState(this.state);
}
