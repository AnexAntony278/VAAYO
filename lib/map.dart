import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class VaayoMap extends StatefulWidget {
  const VaayoMap({super.key});

  @override
  State<VaayoMap> createState() => _VaayoMapState();
}

class _VaayoMapState extends State<VaayoMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: const Text("Google search places API"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            children: [
              const Text("To"),
              TextField(
                onChanged: (value) {
                  debugPrint(value);
                },
              ),
              Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  height: MediaQuery.of(context).size.height / 2,
                  child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(9.853135, 76.947712),
                        initialZoom: 17,
                        backgroundColor: Colors.red,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: [
                            'a',
                            'b',
                            'c'
                          ], // Subdomains for the tile server
                        ),
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
