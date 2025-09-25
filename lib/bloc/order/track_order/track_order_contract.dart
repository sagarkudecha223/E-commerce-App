import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:built_value/built_value.dart';
import 'package:latlong2/latlong.dart';

part 'track_order_contract.g.dart';

abstract class TrackOrderData
    implements Built<TrackOrderData, TrackOrderDataBuilder> {
  factory TrackOrderData([void Function(TrackOrderDataBuilder) updates]) =
      _$TrackOrderData;

  TrackOrderData._();

  ScreenState get state;

  Distance get distance;

  List<LatLng> get routePoints;

  LatLng get source;

  LatLng get destination;

  LatLng? get deliveryBoy;

  String get etaTime;

  String? get errorMessage;
}

abstract class TrackOrderEvent {}

class InitTrackOrderEvent extends TrackOrderEvent {
  final LatLng destination;

  InitTrackOrderEvent({required this.destination});
}

class UpdateTrackOrderState extends TrackOrderEvent {
  final TrackOrderData state;

  UpdateTrackOrderState(this.state);
}

abstract class TrackOrderTarget {
  ///TODO defined like : static const String <var_name> = 'value';
}
