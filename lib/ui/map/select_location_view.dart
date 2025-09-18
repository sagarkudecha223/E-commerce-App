import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/colors.dart';
import '../../core/dimens.dart';
import '../../injector/injection.dart';
import '../../services/map/map_service.dart';
import '../common/app_loader.dart';
import '../common/buttons/icon_button.dart';

class SelectLocationView extends StatefulWidget {
  final Function(LatLng userLocation) onSelectLatLong;

  const SelectLocationView({super.key, required this.onSelectLatLong});

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView>
    with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  final _mapController = MapController();
  late LatLng? _userLocation;
  LatLng? _selectedPoint;
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
    _getInitialPosition();
  }

  _getInitialPosition() async {
    _userLocation = await getIt.get<AppMapController>().initUserLocation();
    if (_userLocation != null) {
      if (mounted) {
        _selectedPoint = _userLocation;
        _animatedMapMove(_userLocation!, 16);
        setState(() {});
      }
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );

      // toggle loader state
      if (id == _inProgressId && !_isAnimating) {
        setState(() => _isAnimating = true);
      } else if (id == _finishedId && _isAnimating) {
        setState(() => _isAnimating = false);
      }
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(51.5, -0.09),
            initialZoom: 5,
            minZoom: 3,
            onTap: (tapPosition, point) {
              setState(() {
                _selectedPoint = point;
              });
              _animatedMapMove(point, 16);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.demo_app',
              tileUpdateTransformer: _animatedMoveTileUpdateTransformer,
            ),
            if (_selectedPoint != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPoint!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(Dimens.spaceSmall),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  iconWidget: Icon(
                    Icons.account_circle_rounded,
                    color: AppColors.white,
                  ),
                  backgroundColor: AppColors.primaryOrange,
                  onTap: _getInitialPosition,
                ),
                AppIconButton(
                  iconWidget: Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.white,
                  ),
                  backgroundColor: AppColors.primaryOrange,
                  onTap: () {
                    if (_selectedPoint != null) {
                      widget.onSelectLatLong(_selectedPoint!);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        if (_isAnimating)
          const Positioned.fill(
            child: ColoredBox(
              color: AppColors.darkTextMedium,
              child: AppLoader(),
            ),
          ),
      ],
    );
  }
}

final _animatedMoveTileUpdateTransformer = TileUpdateTransformer.fromHandlers(
  handleData: (updateEvent, sink) {
    final mapEvent = updateEvent.mapEvent;

    final id = mapEvent is MapEventMove ? mapEvent.id : null;
    if (id?.startsWith(_SelectLocationViewState._startedId) ?? false) {
      final parts = id!.split('#')[2].split(',');
      final lat = double.parse(parts[0]);
      final lon = double.parse(parts[1]);
      final zoom = double.parse(parts[2]);

      // When animated movement starts load tiles at the target location and do
      // not prune. Disabling pruning means existing tiles will remain visible
      // whilst animating.
      sink.add(
        updateEvent.loadOnly(
          loadCenterOverride: LatLng(lat, lon),
          loadZoomOverride: zoom,
        ),
      );
    } else if (id == _SelectLocationViewState._inProgressId) {
      // Do not prune or load whilst animating so that any existing tiles remain
      // visible. A smarter implementation may start pruning once we are close to
      // the target zoom/location.
    } else if (id == _SelectLocationViewState._finishedId) {
      // We already prefetched the tiles when animation started so just prune.
      sink.add(updateEvent.pruneOnly());
    } else {
      sink.add(updateEvent);
    }
  },
);
