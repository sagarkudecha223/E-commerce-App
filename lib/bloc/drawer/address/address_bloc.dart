import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../core/enum.dart';
import '../../../core/routes.dart';
import '../../../localization/app_localization.dart';
import '../../../model/address_model.dart';
import '../../../services/firebase/address_service.dart';
import 'address_contract.dart';

@injectable
class AddressBloc extends BaseBloc<AddressEvent, AddressData> {
  AddressBloc(this._addressService) : super(initState) {
    on<InitAddressEvent>(_initAddressEvent);
    on<MapAddressSelectEvent>(_mapAddressSelectEvent);
    on<AddNewAddressTapEvent>(_addNewAddressTapEvent);
    on<UpdateAddressState>((event, emit) => emit(event.state));
  }

  final AddressService _addressService;

  static AddressData get initState =>
      (AddressDataBuilder()
            ..state = ScreenState.loading
            ..addressList = []
            ..isButtonLoading = false
            ..cityStateCountryController = TextEditingController()
            ..labelController = TextEditingController()
            ..postalCodeController = TextEditingController()
            ..streetController = TextEditingController()
            ..errorMessage = '')
          .build();

  void _initAddressEvent(_, __) async {
    final addresses = await _addressService.fetchAddresses();
    add(
      UpdateAddressState(
        state.rebuild(
          (u) =>
              u
                ..state = ScreenState.content
                ..addressList = addresses,
        ),
      ),
    );
  }

  getTextController(AddressInfoController addressInfoController) {
    switch (addressInfoController) {
      case AddressInfoController.label:
        return state.labelController;
      case AddressInfoController.street:
        return state.streetController;
      case AddressInfoController.cityStateCountry:
        return state.cityStateCountryController;
      case AddressInfoController.postalCode:
        return state.postalCodeController;
    }
  }

  void _mapAddressSelectEvent(MapAddressSelectEvent event, _) => add(
    UpdateAddressState(state.rebuild((u) => u.userLatLong = event.userLatLong)),
  );

  void _addNewAddressTapEvent(_, __) async {
    if (state.labelController.text.isEmpty) {
      _disPlayMessage(
        message: AppLocalization.currentLocalization().enterAddressLabel,
      );
    } else if (state.streetController.text.isEmpty) {
      _disPlayMessage(
        message: AppLocalization.currentLocalization().enterStreetAddress,
      );
    } else if (state.cityStateCountryController.text.isEmpty) {
      _disPlayMessage(
        message: AppLocalization.currentLocalization().enterCityStateCountry,
      );
    } else if (state.postalCodeController.text.isEmpty) {
      _disPlayMessage(
        message: AppLocalization.currentLocalization().enterPostalCode,
      );
    } else if (state.postalCodeController.text.length < 6) {
      _disPlayMessage(
        message: AppLocalization.currentLocalization().enterValidPostalCode,
      );
    } else if (state.userLatLong == null) {
      _disPlayMessage(
        message: AppLocalization.currentLocalization().pleasePinLocationInMap,
      );
    } else {
      add(UpdateAddressState(state.rebuild((u) => u.isButtonLoading = true)));
      await _addressService.addAddress(
        Address(
          id: '',
          label: state.labelController.text,
          street: state.streetController.text,
          cityStateCountry: state.cityStateCountryController.text,
          postalCode: state.postalCodeController.text,
          latLong:
              '${state.userLatLong!.latitude}, ${state.userLatLong!.longitude}',
        ),
      );
      add(UpdateAddressState(state.rebuild((u) => u.isButtonLoading = false)));
      dispatchViewEvent(NavigateScreen(AppRoutes.confirmOrderScreen));
    }
  }

  _disPlayMessage({required String message}) => dispatchViewEvent(
    DisplayMessage(type: DisplayMessageType.toast, message: message),
  );
}
