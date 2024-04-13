import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VaayoMap extends StatefulWidget {
  const VaayoMap({Key? key});

  @override
  State<VaayoMap> createState() => _VaayoMapState();
}

class _VaayoMapState extends State<VaayoMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
              child: Column(
            children: [
              Text("Sample Maps"),
              SizedBox(
                  width: 400,
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.satellite,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(37.43296265331129, -122.08832357078792),
                        zoom: 13),
                  )),
            ],
          )),
        ),
      ),
    );
  }
}
