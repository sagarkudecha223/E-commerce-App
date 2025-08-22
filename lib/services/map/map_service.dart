import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

@singleton
class AppMapController {
  final MapController mapController = MapController();

  LatLng? userLocation;
  final Map<String, LatLng> deliveryBoys = {};

  /// Get all markers (user + delivery boys)
  List<Marker> get markers {
    final markers = <Marker>[];

    if (userLocation != null) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: userLocation!,
          child: const Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 36,
          ),
        ),
      );
    }

    deliveryBoys.forEach((id, loc) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: loc,
          child: const Icon(
            Icons.delivery_dining,
            color: Colors.green,
            size: 32,
          ),
        ),
      );
    });

    return markers;
  }

  /// Ask for permission and return true if allowed
  Future<bool> _handlePermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final req = await Permission.location.request();
      if (req.isGranted) return true;
    }

    return false;
  }

  /// Initialize user location
  Future<LatLng?> initUserLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    userLocation = LatLng(pos.latitude, pos.longitude);

    return userLocation;
  }

  /// Update delivery boy location
  void updateDeliveryBoy(String id, double lat, double lng) {
    deliveryBoys[id] = LatLng(lat, lng);
  }

  /// Remove delivery boy
  void removeDeliveryBoy(String id) {
    deliveryBoys.remove(id);
  }

  /// Animate map to location
  void animateTo(double lat, double lng, {double zoom = 14}) {
    mapController.move(LatLng(lat, lng), zoom);
  }
}
