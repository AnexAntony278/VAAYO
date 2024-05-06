import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistanceCalculator {
  static const earthRadius = 6371.0; // Earth radius in kilometers

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  static double calculateDistance(LatLng start, LatLng end) {
    double startLatitude = start.latitude;
    double startLongitude = start.longitude;
    double endLatitude = end.latitude;
    double endLongitude = end.longitude;

    double dLat = degreesToRadians(endLatitude - startLatitude);
    double dLon = degreesToRadians(endLongitude - startLongitude);

    double a = pow(sin(dLat / 2), 2) +
        cos(degreesToRadians(startLatitude)) *
            cos(degreesToRadians(endLatitude)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}
