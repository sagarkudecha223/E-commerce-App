import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:bloc_base_architecture/imports/package_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../bloc/order/track_order/track_order_bloc.dart';
import '../../../bloc/order/track_order/track_order_contract.dart';
import '../../../core/colors.dart';
import '../../../core/dimens.dart';
import '../../../core/images.dart';
import '../../../core/styles.dart';
import '../../../localization/app_localization.dart';
import '../../common/app_bar.dart';
import '../../common/app_loader.dart';
import '../../common/buttons/icon_button.dart';
import '../../decoration/screen_background.dart';
import '../../full_screen_error/full_screen_error.dart';

class TrackOrderScreen extends StatefulWidget {
  final LatLng destination;

  const TrackOrderScreen({super.key, required this.destination});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState
    extends BaseState<TrackOrderBloc, TrackOrderScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    bloc.add(InitTrackOrderEvent(destination: widget.destination));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackGroundColor,
      appBar: CommonAppBar(
        title: AppLocalization.currentLocalization().trackOrder,
      ),
      body: SafeArea(
        child: BlocProvider<TrackOrderBloc>(
          create: (_) => bloc,
          child: BlocBuilder<TrackOrderBloc, TrackOrderData>(
            builder:
                (_, __) =>
                    _MainContent(bloc: bloc, mapController: _mapController),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc, required this.mapController});

  final MapController mapController;
  final TrackOrderBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.loading:
        return const AppLoader();
      case ScreenState.content:
        return _TrackerContent(state: bloc.state, mapController: mapController);
      default:
        return FullScreenError(
          message: bloc.state.errorMessage!,
          onRetryTap:
              () => bloc.add(
                InitTrackOrderEvent(destination: bloc.state.destination),
              ),
        );
    }
  }
}

class _TrackerContent extends StatelessWidget {
  final TrackOrderData state;
  final MapController mapController;

  const _TrackerContent({required this.state, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ScreenBackground(),
      padding: const EdgeInsets.all(Dimens.spaceLarge),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.radiusMedium),
            ),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: state.source,
                initialZoom: 15,
                minZoom: 3,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.demo_app',
                ),
                if (state.routePoints.isNotEmpty)
                  _Polyline(points: state.routePoints),
                _Markers(state: state),
              ],
            ),
          ),
          Positioned(
            top: Dimens.space3xMedium,
            left: Dimens.space3xMedium,
            child: Container(
              padding: const EdgeInsets.all(Dimens.space2xSmall),
              decoration: BoxDecoration(
                color: AppColors.lightTextMedium,
                borderRadius: BorderRadius.circular(Dimens.radius2xSmall),
              ),
              child: Text(
                '${AppLocalization.currentLocalization().estimatedTime} : ${state.etaTime}',
                style: AppFontTextStyles.textStyleMedium().copyWith(
                  color: AppColors.white,
                  fontSize: Dimens.fontSizeSixteen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Polyline extends StatelessWidget {
  const _Polyline({required this.points});

  final List<LatLng> points;

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        Polyline(points: points, strokeWidth: 5.0, color: Colors.orange),
      ],
    );
  }
}

class _Markers extends StatelessWidget {
  final TrackOrderData state;

  const _Markers({required this.state});

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        commonMarker(image: Images.orders, point: state.source),
        commonMarker(image: Images.home, point: state.destination),
        if (state.deliveryBoy != null)
          commonMarker(image: Images.deliveryBoy, point: state.deliveryBoy!),
      ],
    );
  }
}

commonMarker({required LatLng point, required String image}) => Marker(
  height: Dimens.iconXLarge,
  width: Dimens.iconXLarge,
  point: point,
  child: AppIconButton(
    svgImage: image,
    imageColor: AppColors.white,
    imageHeight: Dimens.iconLarge,
    hasBorder: true,
    disabledColor: AppColors.primaryOrange,
  ),
);
