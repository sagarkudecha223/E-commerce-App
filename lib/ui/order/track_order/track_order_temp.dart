import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingExample extends StatefulWidget {
  const RoutingExample({super.key});

  @override
  State<RoutingExample> createState() => _RoutingExampleState();
}

class _RoutingExampleState extends State<RoutingExample> {
  final MapController _mapController = MapController();
  final Distance distance = const Distance();

  List<LatLng> routePoints = [];
  LatLng source = LatLng(23.0600, 72.5800);
  LatLng destination = LatLng(23.0615, 72.5950);

  LatLng? deliveryBoy;
  Timer? _timer;
  int currentIndex = 0;
  double traveled = 0.0;
  double totalDistance = 0.0;
  double remainingDistance = 0.0;

  String eta = "Calculating...";

  Future<void> fetchRoute() async {
    final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car'
      '?api_key=eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImZkY2ExODFlMmZlZTQ5OGNhN2YyYzAwMDA2OGVmMGNjIiwiaCI6Im11cm11cjY0In0='
      '&start=72.5800,23.0600'
      '&end=72.5950,23.0615',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['features'] != null && data['features'].isNotEmpty) {
      final coords = data['features'][0]['geometry']['coordinates'] as List;
      final points = coords.map((c) => LatLng(c[1], c[0])).toList();

      // Calculate total route distance
      double total = 0;
      for (int i = 0; i < points.length - 1; i++) {
        total += distance(points[i], points[i + 1]);
      }

      setState(() {
        routePoints = points;
        totalDistance = total;
        remainingDistance = total;
        deliveryBoy = points.first;
      });

      startMoving();
    } else {
      print("No route found");
    }
  }

  void startMoving() {
    _timer?.cancel();
    currentIndex = 0;
    double distanceToMove = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIndex >= routePoints.length - 1) {
        timer.cancel();
        setState(() {
          eta = "Arrived 🚩";
        });
        return;
      }

      distanceToMove = 100; // 100m per tick
      LatLng pos = deliveryBoy ?? routePoints.first;

      while (distanceToMove > 0 && currentIndex < routePoints.length - 1) {
        final current = pos;
        final next = routePoints[currentIndex + 1];
        final segDist = distance(current, next);

        if (segDist <= distanceToMove) {
          // consume full segment
          distanceToMove -= segDist;
          pos = next;
          currentIndex++;
        } else {
          // move inside this segment
          final fraction = distanceToMove / segDist;
          final newLat = current.latitude + (next.latitude - current.latitude) * fraction;
          final newLng = current.longitude + (next.longitude - current.longitude) * fraction;
          pos = LatLng(newLat, newLng);
          distanceToMove = 0;
        }
      }

      // update position & remaining distance
      setState(() {
        deliveryBoy = pos;
        remainingDistance = distance(pos, destination);

        // recalc ETA
        double remainingSeconds = remainingDistance / 100; // speed = 100m/s
        int min = remainingSeconds ~/ 60;
        int sec = (remainingSeconds % 60).round();
        eta = "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')} left";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: source,
              initialZoom: 15,
              minZoom: 3,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.demo_app',
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5.0,
                      color: Colors.orange,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: source,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  Marker(
                    point: destination,
                    child: const Icon(
                      Icons.flag,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  if (deliveryBoy != null)
                    Marker(
                      point: deliveryBoy!,
                      child: const Icon(
                        Icons.pedal_bike,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "ETA: $eta",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
