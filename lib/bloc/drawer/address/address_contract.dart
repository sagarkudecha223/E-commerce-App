import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as material;
import 'package:latlong2/latlong.dart';

import '../../../model/address_model.dart';

part 'address_contract.g.dart';

abstract class AddressData implements Built<AddressData, AddressDataBuilder> {
  factory AddressData([void Function(AddressDataBuilder) updates]) =
      _$AddressData;

  AddressData._();

  ScreenState get state;

  List<Address> get addressList;

  material.TextEditingController get labelController;

  material.TextEditingController get streetController;

  material.TextEditingController get cityStateCountryController;

  material.TextEditingController get postalCodeController;

  bool get isButtonLoading;

  LatLng? get userLatLong;

  String? get errorMessage;
}

abstract class AddressEvent {}

class InitAddressEvent extends AddressEvent {}

class AddNewAddressTapEvent extends AddressEvent {}

class MapAddressSelectEvent extends AddressEvent {
  final LatLng userLatLong;

  MapAddressSelectEvent({required this.userLatLong});
}

class UpdateAddressState extends AddressEvent {
  final AddressData state;

  UpdateAddressState(this.state);
}
