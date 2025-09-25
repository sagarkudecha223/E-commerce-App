import 'package:bloc_base_architecture/imports/api_imports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@singleton
class MapRouteService {
  final RestApiClient _restApiClient;

  MapRouteService(this._restApiClient);

  Future<ResponseEntity<List<LatLng>>> fetchRoute({required LatLng destination}) async {
    String lonLat = "${destination.longitude.toStringAsFixed(4)},${destination.latitude.toStringAsFixed(4)}";
    String mapApiKey = dotenv.get('MAP_KEY');
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car'
        '?api_key=$mapApiKey'
        '&start=72.5800,23.0600'
        '&end=$lonLat';

    final response = await _restApiClient.request(
      path: url,
      requestMethod: RequestMethod.get,
      data: RequestData(data: null, type: RequestDataType.body),
    );
    if (response.isSuccess) {
      final data = response.data;

      if (data?['features'] != null && data?['features'].isNotEmpty) {
        final coords = data?['features'][0]['geometry']['coordinates'] as List;

        final points = coords.map((c) => LatLng(c[1], c[0])).toList();
        return ResponseEntity(points, null);
      } else {
        return ResponseEntity(
          null,
          ErrorResult(
            errorMessage: "No route found",
            type: ErrorResultType.other,
          ),
        );
      }
    }
    return ResponseEntity(null, response.errorResult);
  }
}
