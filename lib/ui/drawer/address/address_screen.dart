import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

import '../../../bloc/drawer/address/address_bloc.dart';
import '../../../bloc/drawer/address/address_contract.dart';
import '../../../core/colors.dart';
import '../../../core/constants.dart';
import '../../../core/dimens.dart';
import '../../../core/enum.dart';
import '../../../core/enum_extensions.dart';
import '../../../core/routes.dart';
import '../../../core/toast.dart';
import '../../../localization/app_localization.dart';
import '../../common/app_bar.dart';
import '../../common/app_loader.dart';
import '../../common/app_toast.dart';
import '../../common/buttons/elevated_button.dart';
import '../../common/text_field.dart';
import '../../decoration/container_decoration.dart';
import '../../decoration/screen_background.dart';
import '../../full_screen_error/full_screen_error.dart';
import '../../map/select_location_view.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends BaseState<AddressBloc, AddressScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitAddressEvent());
  }

  @override
  void onViewEvent(ViewAction event) {
    switch (event.runtimeType) {
      case const (NavigateScreen):
        _buildHandleActionEvent(event as NavigateScreen);
      case const (DisplayMessage):
        _buildHandleMessage(event as DisplayMessage);
    }
  }

  void _buildHandleMessage(DisplayMessage displayMessage) {
    final message = displayMessage.message;
    final type = displayMessage.type;
    switch (type) {
      case DisplayMessageType.toast:
        showToast(AppToast(message: message!), context);
      default:
        break;
    }
  }

  void _buildHandleActionEvent(NavigateScreen screen) {
    switch (screen.target) {
      case AppRoutes.confirmOrderScreen:
        navigatorKey.currentContext?.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: CommonAppBar(
        title: AppLocalization.currentLocalization().deliveryAddress,
      ),
      body: SafeArea(
        child: BlocProvider<AddressBloc>(
          create: (_) => bloc,
          child: BlocBuilder<AddressBloc, AddressData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final AddressBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _AddressContent(bloc: bloc);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap: () {
            /// NOTE : retry event : bloc.add(<event_name>)
          },
        );
    }
  }
}

class _AddressContent extends StatelessWidget {
  final AddressBloc bloc;

  const _AddressContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ScreenBackground(),
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.spaceMedium,
        vertical: Dimens.spaceMedium,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TextControllerView(bloc: bloc),
            const Gap(Dimens.spaceLarge),
            _MapView(
              onSelectLatLong:
                  (userLocation) => bloc.add(
                    MapAddressSelectEvent(userLatLong: userLocation),
                  ),
            ),
            const Gap(Dimens.spaceLarge),
            _AddAddressButton(
              onTap: () => bloc.add(AddNewAddressTapEvent()),
              isLoading: bloc.state.isButtonLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  final Function(LatLng userLocation) onSelectLatLong;

  const _MapView({required this.onSelectLatLong});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      decoration: ContainerDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radiusLarge)),
        child: SelectLocationView(onSelectLatLong: onSelectLatLong),
      ),
    );
  }
}

class _TextControllerView extends StatelessWidget {
  final AddressBloc bloc;

  const _TextControllerView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder:
          (_, index) => _TextField(
            addressInfoController: AddressInfoController.values[index],
            textEditingController: bloc.getTextController(
              AddressInfoController.values[index],
            ),
          ),
      itemCount: AddressInfoController.values.length,
    );
  }
}

class _TextField extends StatelessWidget {
  final AddressInfoController addressInfoController;
  final TextEditingController textEditingController;

  const _TextField({
    required this.addressInfoController,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.space2xSmall),
      child: AppTextField(
        labelText: addressInfoController.title,
        textEditingController: textEditingController,
        hintText: addressInfoController.hint,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class _AddAddressButton extends StatelessWidget {
  final bool isLoading;
  final Function() onTap;

  const _AddAddressButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      title: AppLocalization.currentLocalization().addAddress,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}
