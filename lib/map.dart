import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VaayoMap extends StatefulWidget {
  const VaayoMap({super.key});

  @override
  State<VaayoMap> createState() => _VaayoMapState();
}

class _VaayoMapState extends State<VaayoMap> {
  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
        initialCameraPosition: CameraPosition(
            target: const LatLng(37.42796133580664, -122.085749655962),
            zoom: 13));
  }
}
