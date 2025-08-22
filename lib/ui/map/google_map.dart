import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/colors.dart';
import '../../core/images.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(12.9716, 77.5959);
  static const LatLng destination = LatLng(13.0196, 77.5854);
  LatLng carLocation = const LatLng(12.9716, 77.5959);

  // Maintain polyLine coordinates in a list
  List<LatLng> polyLineCoordinates = [];

  StreamController<List<LatLng>> polyLineStreamController =
      StreamController<List<LatLng>>();
  StreamController<LatLng> locationStreamController =
      StreamController<LatLng>();

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor driverIcon;

  ValueNotifier<double> progress = ValueNotifier(
    0.0,
  ); // Progress of car movement

  // Function to calculate the progress as a percentage (0.0 to 1.0)
  double calculateProgress(LatLng currentLocation) {
    double totalDistance = _calculateTotalDistance();
    double traveledDistance = _calculateTraveledDistance(currentLocation);
    return traveledDistance / totalDistance;
  }

  double _calculateTotalDistance() {
    double distance = 0.0;
    for (int i = 0; i < polyLineCoordinates.length - 1; i++) {
      distance += _coordinateDistance(
        polyLineCoordinates[i].latitude,
        polyLineCoordinates[i].longitude,
        polyLineCoordinates[i + 1].latitude,
        polyLineCoordinates[i + 1].longitude,
      );
    }
    return distance;
  }

  double _calculateTraveledDistance(LatLng currentLocation) {
    double traveled = 0.0;
    for (int i = 0; i < polyLineCoordinates.length - 1; i++) {
      LatLng point = polyLineCoordinates[i];
      if (point == currentLocation) {
        break;
      }
      traveled += _coordinateDistance(
        polyLineCoordinates[i].latitude,
        polyLineCoordinates[i].longitude,
        polyLineCoordinates[i + 1].latitude,
        polyLineCoordinates[i + 1].longitude,
      );
    }
    return traveled;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a =
        0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // Mocking current location
  // You can also take user current location using [location] Package
  // and perform calculation according to that.
  void mockCurrentLocation() async {
    GoogleMapController googleMapController = await _controller.future;

    for (int i = 0; i < polyLineCoordinates.length - 1; i++) {
      LatLng nextPoint = polyLineCoordinates[i + 1];

      await Future.delayed(const Duration(milliseconds: 500), () {
        carLocation = nextPoint;
        locationStreamController.sink.add(carLocation);

        // Update progress
        progress.value = calculateProgress(carLocation);

        // Update camera position to follow the current location
        googleMapController.animateCamera(CameraUpdate.newLatLng(carLocation));
      });
    }
  }

  // Function to draw polyLine between Source and Destination
  void getPolyLines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.get("MAPS_API_KEY"),
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    polyLineCoordinates.clear();

    if (result.points.isNotEmpty) {
      for (final resultPoint in result.points) {
        polyLineCoordinates.add(
          LatLng(resultPoint.latitude, resultPoint.longitude),
        );
      }
    }

    polyLineStreamController.sink.add(polyLineCoordinates);
    mockCurrentLocation();
  }

  // Setting custom markers
  void customMarker() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sourceIcon = await BitmapDescriptor.asset(
        ImageConfiguration.empty,
        Images.location,
        height: 40,
        width: 40,
      );
      destinationIcon = await BitmapDescriptor.asset(
        ImageConfiguration.empty,
        Images.home,
        height: 40,
        width: 40,
      );
      driverIcon = await BitmapDescriptor.asset(
        ImageConfiguration.empty,
        Images.deliveryBike,
        height: 32,
        width: 32,
      );
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    customMarker();
    getPolyLines();
  }

  @override
  void dispose() {
    polyLineStreamController.close();
    locationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          // height: MediaQuery.sizeOf(context).height * 0.50,
          height: 500,
          width: 500,
          child: StreamBuilder<List<LatLng>>(
            stream: polyLineStreamController.stream,
            builder: (context, polyLineSnapshot) {
              if (!polyLineSnapshot.hasData) {
                return const Center(child: Text("No Route Found"));
              }
              return StreamBuilder<LatLng>(
                stream: locationStreamController.stream,
                initialData: carLocation,
                builder: (context, locationSnapshot) {
                  if (!locationSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Google Map with polyLine
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: locationSnapshot.data!,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('source'),
                        position: sourceLocation,
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                      Marker(
                        markerId: const MarkerId('destination'),
                        position: destination,
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                      Marker(
                        markerId: const MarkerId('driver'),
                        position: locationSnapshot.data!,
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: polyLineSnapshot.data!,
                        color: AppColors.primaryOrange,
                        width: 5,
                      ),
                    },
                    onMapCreated: (mapController) {
                      _controller.complete(mapController);
                    },
                  );
                },
              );
            },
          ),
        ),
        // Progress Indicator and Location info.
        /* Container(
          color: const Color(0xff293653),
          // height: MediaQuery.sizeOf(context).height * 0.25,
          height: 200,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: progress,
                  builder: (context, value, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 12,
                          ),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(4),
                            minHeight: 10,
                            value: value,
                            backgroundColor: AppColors.primaryOrange,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryOrange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            "Deadpool is on the way...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      SourceAndDestinationImageWidget(),
                      SizedBox(width: 12),
                      // Source and Destination Field widget
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LocationFieldWidget(location: "Stark Tower"),
                          SizedBox(height: 18),
                          LocationFieldWidget(location: "Wayne Manor"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),*/
      ],
    );
  }
}

class LocationFieldWidget extends StatelessWidget {
  final String location;

  const LocationFieldWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.8,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff525458)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        location,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

class SourceAndDestinationImageWidget extends StatelessWidget {
  const SourceAndDestinationImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Source Icon Image
        Image.asset(Images.location, height: 28, width: 28),
        // Dotted Line widget
        const DottedLine(),
        // Destination Icon Image
        Image.asset(Images.location, height: 28, width: 28),
      ],
    );
  }
}

class DottedLine extends StatelessWidget {
  const DottedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 2),
          Container(height: 4, width: 2, color: Colors.white),
          const SizedBox(height: 3),
          Container(height: 4, width: 2, color: Colors.white),
          Container(height: 4, width: 2, color: Colors.white),
          const SizedBox(height: 3),
          Container(height: 4, width: 2, color: Colors.white),
        ],
      ),
    );
  }
}
