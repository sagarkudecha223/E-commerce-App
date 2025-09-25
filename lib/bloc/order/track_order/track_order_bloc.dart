import 'dart:async';

import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import '../../../services/map/map_route_service.dart';
import 'track_order_contract.dart';

@injectable
class TrackOrderBloc extends BaseBloc<TrackOrderEvent, TrackOrderData> {
  TrackOrderBloc(this._mapRouteService) : super(initState) {
    on<InitTrackOrderEvent>(_initTrackOrderEvent);
    on<UpdateTrackOrderState>((event, emit) => emit(event.state));
  }

  final MapRouteService _mapRouteService;

  Timer? _timer;
  int currentIndex = 0;
  double traveled = 0.0;
  double totalDistance = 0.0;
  double remainingDistance = 0.0;

  static TrackOrderData get initState =>
      (TrackOrderDataBuilder()
            ..state = ScreenState.loading
            ..source = LatLng(23.0600, 72.5800)
            ..destination = LatLng(23.0600, 72.5800)
            ..etaTime = "Calculating..."
            ..routePoints = []
            ..distance = Distance()
            ..errorMessage = '')
          .build();

  void _initTrackOrderEvent(InitTrackOrderEvent event, __) async {
    final response = await _mapRouteService.fetchRoute(
      destination: event.destination,
    );
    if (response.data != null) {
      final points = response.data ?? [];
      double total = 0;
      for (int i = 0; i < points.length - 1; i++) {
        total += state.distance(points[i], points[i + 1]);
      }

      totalDistance = total;
      remainingDistance = total;

      _startMoving();

      add(
        UpdateTrackOrderState(
          state.rebuild(
            (u) =>
                u
                  ..state = ScreenState.content
                  ..routePoints = points
                  ..deliveryBoy = points.first
                  ..destination = event.destination,
          ),
        ),
      );
    } else {
      add(
        UpdateTrackOrderState(
          state.rebuild(
            (u) =>
                u
                  ..state = ScreenState.error
                  ..errorMessage = response.errorResult?.errorMessage,
          ),
        ),
      );
    }
  }

  void _startMoving() {
    _timer?.cancel();
    currentIndex = 0;
    double distanceToMove = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIndex >= state.routePoints.length - 1) {
        timer.cancel();

        add(
          UpdateTrackOrderState(state.rebuild((u) => u..etaTime = "Arrived")),
        );
        return;
      }

      distanceToMove = 50;
      LatLng pos = state.deliveryBoy ?? state.routePoints.first;

      while (distanceToMove > 0 &&
          currentIndex < state.routePoints.length - 1) {
        final current = pos;
        final next = state.routePoints[currentIndex + 1];
        final segDist = state.distance(current, next);

        if (segDist <= distanceToMove) {
          // consume full segment
          distanceToMove -= segDist;
          pos = next;
          currentIndex++;
        } else {
          // move inside this segment
          final fraction = distanceToMove / segDist;
          final newLat =
              current.latitude + (next.latitude - current.latitude) * fraction;
          final newLng =
              current.longitude +
              (next.longitude - current.longitude) * fraction;
          pos = LatLng(newLat, newLng);
          distanceToMove = 0;
        }
      }
      remainingDistance = state.distance(pos, state.destination);
      double remainingSeconds = remainingDistance / 50; // speed = 100m/s
      int min = remainingSeconds ~/ 60;
      int sec = (remainingSeconds % 60).round();
      add(
        UpdateTrackOrderState(
          state.rebuild(
            (u) =>
                u
                  ..state = ScreenState.content
                  ..etaTime =
                      "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}"
                  ..deliveryBoy = pos,
          ),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
