import 'package:bloc_base_architecture/extension/navigation_extensions.dart';
import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../bloc/order/confirm_order/confirm_order_bloc.dart';
import '../../../bloc/order/confirm_order/confirm_order_contract.dart';
import '../../../core/colors.dart';
import '../../../core/constants.dart';
import '../../../core/dimens.dart';
import '../../../core/routes.dart';
import '../../../core/styles.dart';
import '../../../core/toast.dart';
import '../../../localization/app_localization.dart';
import '../../../model/address_model.dart';
import '../../cart/cart_screen.dart';
import '../../common/app_bar.dart';
import '../../common/app_drop_down.dart';
import '../../common/app_inkwell.dart';
import '../../common/app_loader.dart';
import '../../common/app_toast.dart';
import '../../common/buttons/elevated_button.dart';
import '../../common/buttons/icon_button.dart';
import '../../decoration/screen_background.dart';
import '../../drawer/address/address_screen.dart';
import '../../full_screen_error/full_screen_error.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState
    extends BaseState<ConfirmOrderBloc, ConfirmOrderScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitConfirmOrderEvent());
  }

  @override
  void onViewEvent(ViewAction event) {
    switch (event.runtimeType) {
      case const (DisplayMessage):
        _buildHandleMessage(event as DisplayMessage);
      case const (NavigateScreen):
        _buildHandleActionEvent(event as NavigateScreen);
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
      case AppRoutes.addressScreen:
        navigatorKey.currentContext?.push(
          builder: (context) => AddressScreen(),
          settings: RouteSettings(name: screen.target),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: CommonAppBar(
        title: AppLocalization.currentLocalization().confirmOrder,
      ),
      body: SafeArea(
        child: BlocProvider<ConfirmOrderBloc>(
          create: (_) => bloc,
          child: BlocBuilder<ConfirmOrderBloc, ConfirmOrderData>(
            builder: (_, __) => _MainContent(bloc: bloc),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final ConfirmOrderBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _OrderContent(bloc: bloc);
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

class _OrderContent extends StatelessWidget {
  final ConfirmOrderBloc bloc;

  const _OrderContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ScreenBackground(),
      height: double.infinity,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spaceMedium),
              child: Column(
                children: [
                  const Gap(Dimens.spaceSmall),
                  _AddressView(bloc: bloc),
                  const Gap(Dimens.spaceSmall),
                  CartScreen(isFromTab: false),
                ],
              ),
            ),
          ),
          if (bloc.state.itemList.isNotEmpty) _PaymentView(bloc: bloc),
        ],
      ),
    );
  }
}

class _AddressView extends StatelessWidget {
  final ConfirmOrderBloc bloc;

  const _AddressView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppInkWell(
            onTap: () => bloc.add(AddAddressEvent()),
            child: IgnorePointer(
              ignoring: bloc.state.selectedAddress == null,
              child: AppDropDown<Address>(
                initialValue: bloc.state.selectedAddress?.label,
                labelText:
                    AppLocalization.currentLocalization().shippingAddress,
                leadingIcon: Icon(
                  Icons.location_on_rounded,
                  size: Dimens.iconMedium,
                  color: AppColors.primaryOrange,
                ),
                onChanged: (_) {},
                items: bloc.state.addressList,
                itemLabel: (address) => address.label,
              ),
            ),
          ),
        ),
        AppIconButton(
          iconWidget: Icon(Icons.add, color: AppColors.white),
          onTap: () => bloc.add(AddAddressEvent()),
          backgroundColor: AppColors.primaryOrange,
        ),
      ],
    );
  }
}

class _PaymentView extends StatelessWidget {
  final ConfirmOrderBloc bloc;

  const _PaymentView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: ScreenBackground(
          backgroundColor: AppColors.secondaryYellow,
        ),
        padding: EdgeInsets.symmetric(
          vertical: Dimens.space2xSmall,
          horizontal: Dimens.space4xLarge,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AmountView(
                    title: AppLocalization.currentLocalization().subTotal,
                    amount: bloc.state.totalPrice,
                  ),
                  const Gap(Dimens.space5xSmall),
                  _AmountView(
                    title: AppLocalization.currentLocalization().taxFees,
                    amount: 20,
                  ),
                  const Gap(Dimens.space5xSmall),
                  _AmountView(
                    title: AppLocalization.currentLocalization().delivery,
                    amount: 15,
                  ),
                  const Gap(Dimens.space5xSmall),
                  _AmountView(
                    title: AppLocalization.currentLocalization().total,
                    amount: bloc.state.totalPrice,
                  ),
                ],
              ),
            ),
            const Gap(Dimens.space3xSmall),
            Expanded(
              child: AppElevatedButton(
                onTap: () => bloc.add(PlaceOrderTapEvent()),
                isLoading: bloc.state.isPaymentLoading,
                title: AppLocalization.currentLocalization().placeOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountView extends StatelessWidget {
  final String title;
  final num amount;

  const _AmountView({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppFontTextStyles.textStyleBold().copyWith(
              color: AppColors.lightTextHigh,
            ),
          ),
        ),
        Expanded(
          child: Text(
            AppLocalization.currentLocalization().amount(amount.toString()),
            style: AppFontTextStyles.textStyleBold().copyWith(
              color: AppColors.lightTextHigh,
            ),
          ),
        ),
      ],
    );
  }
}
