import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DirectionsRepository {
  static const String _baseUrl = 
      'https://maps.googleapis.com/maps/api/directions/json';

  final String _googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  final Dio _dio = Dio();

  Future<DirectionsResult?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': _googleMapsApiKey,
          'mode': 'driving',
        },
      );

      if (response.statusCode == 200) {
        final result = DirectionsResult.fromJson(response.data);
        return result;
      }
      return null;
    } catch (e) {
      print('Error fetching directions: $e');
      return null;
    }
  }
}

class DirectionsResult {
  final String? distance;
  final String? duration;
  final LatLngBounds bounds;
  final List<LatLng> polylinePoints;

  DirectionsResult({
    required this.distance,
    required this.duration,
    required this.bounds,
    required this.polylinePoints,
  });

  factory DirectionsResult.fromJson(Map<String, dynamic> json) {
    // Get distance and duration from the route
    String? distance;
    String? duration;
    
    if (json['routes'] != null && json['routes'].isNotEmpty) {
      final route = json['routes'][0];
      distance = route['legs'][0]['distance']['text'];
      duration = route['legs'][0]['duration']['text'];
    }

    // Decode polyline
    final polylinePoints = <LatLng>[];
    if (json['routes'] != null && json['routes'].isNotEmpty) {
      final route = json['routes'][0];
      final polyline = route['overview_polyline']['points'];
      
      final points = PolylinePoints.decodePolyline(polyline);
      for (final point in points) {
        polylinePoints.add(LatLng(point.latitude, point.longitude));
      }
    }

    // Get bounds
    LatLngBounds bounds = LatLngBounds(
      northeast: const LatLng(0, 0),
      southwest: const LatLng(0, 0),
    );

    if (json['routes'] != null && json['routes'].isNotEmpty) {
      final route = json['routes'][0];
      final boundsData = route['bounds'];
      bounds = LatLngBounds(
        northeast: LatLng(
          boundsData['northeast']['lat'],
          boundsData['northeast']['lng'],
        ),
        southwest: LatLng(
          boundsData['southwest']['lat'],
          boundsData['southwest']['lng'],
        ),
      );
    }

    return DirectionsResult(
      distance: distance,
      duration: duration,
      bounds: bounds,
      polylinePoints: polylinePoints,
    );
  }
}
