import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'package:vaayo/src/constants/keys.dart';
import 'package:vaayo/src/constants/theme.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage({super.key});

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  Map<String, dynamic> trip = {
        // 'departure_time': Timestamp.now(),
        // 'status': 'WAITING',
        // 'total_seats': 3,
        // 'id': 'CkwnJWIrDttowxMhyvsz',
        // 'departure': 'Painavu',
        // 'destination': 'Cheruthoni',
        // 'available_seats': 3,
        // 'driver_uid': 'b9vDMSNhYjQXRndiJCequ1pviH82',
        // 'passengers': [{'uid':'zqMqFXzEguPEtnSChHf4Z1XLaMB2','status':'BOARDED'}],
        // 'car_no': 'KL21K2222'
      },
      driver = {
        // 'age': 21,
        // 'cars': [
        //   {'no': 'KL21K2222', 'model': 'Celerio'}
        // ],
        // 'bio': ' Btech student',
        // 'phone': "7736110274",
        // 'tags': [],
        // 'name': 'Anandu',
        // 'gender': 'M',
        // 'email': 'anandudina2003@gmail.com'
      };
  List<Map<String, dynamic>> passengers = [
    // {
    //   'age': 21,
    //   'cars': [
    //     {'no': ' KL 17 N 6665', 'model': 'Celerio'}
    //   ],
    //   'bio': ' Btech student',
    //   'phone': "7736110274",
    //   'tags': [],
    //   'name': 'Anandu',
    //   'gender': 'M',
    //   'email': 'anandudina2003@gmail.com'
    // }
  ];
  bool _isLoading = true;
  late LatLng? userLocation, sourceLocation, destinationLocation;
  List<LatLng> _routePolyLinePoints = [];
  String? uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List<Map<String, dynamic>>? arguments = ModalRoute.of(context)
        ?.settings
        .arguments as List<Map<String, dynamic>>?;
    if (arguments != null && arguments.isNotEmpty && arguments.length >= 2) {
      trip = arguments[0];
      driver = arguments[1];
      _getPassengerDetails();
    }
    _getUID();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = (trip['departure_time'] as Timestamp).toDate();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ride Details"),
          actions: const [
            Icon(
              (Icons.time_to_leave),
              size: 40,
            ),
            SizedBox(
              width: 20,
            ),
          ],
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.blueGrey[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            controller: ScrollController(initialScrollOffset: 300),
            children: [
              (trip['status'] != "CREATED")
                  ? Card(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 300,
                          child: Builder(
                            builder: (context) {
                              if (_isLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                        target: userLocation!, zoom: 13),
                                    markers: {
                                      Marker(
                                          markerId: const MarkerId('source'),
                                          position: sourceLocation!),
                                      Marker(
                                          markerId:
                                              const MarkerId('destination'),
                                          position: destinationLocation!),
                                      Marker(
                                          icon: BitmapDescriptor
                                              .defaultMarkerWithHue(
                                                  BitmapDescriptor.hueAzure),
                                          markerId: const MarkerId('user'),
                                          position: userLocation!),
                                    },
                                    polylines: {
                                      Polyline(
                                        polylineId: const PolylineId('route'),
                                        points: _routePolyLinePoints,
                                        color: Colors.purple,
                                        width: 5,
                                      ),
                                    });
                              }
                            },
                          )),
                    )
                  : const Text(""),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              trip['departure'],
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              style: VaayoTheme.largeBold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 45,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              trip['destination'],
                              maxLines: 3,
                              textAlign: TextAlign.right,
                              style: VaayoTheme.largeBold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          //TIME
                          Text(
                            "${date.day} ${date.toMonth()} ${date.year}\n   ${date.hour % 12}:${date.minute} ${date.toAMPM()}",
                            textAlign: TextAlign.center,
                            style: VaayoTheme.mediumBold,
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: .5,
                          ),
                          Text(trip['status'],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.green)),

                          const Row(
                            children: [
                              Text("\tDriver details"),
                            ],
                          ),
                          Card(
                            elevation: 20,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${driver['name']}",
                                          style: VaayoTheme.largeBold),
                                      Text(
                                        "${List.from(driver['cars']).where((car) => car['no'] == trip['car_no']).first['model']}",
                                        style: VaayoTheme.mediumBold,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                          onPressed: () =>
                                              _callPhone(driver['phone']),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.call),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('CALL'),
                                            ],
                                          ))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const CircleAvatar(
                                        radius: 40,
                                        child: Icon(
                                          Icons.account_circle,
                                          size: 40,
                                        ),
                                      ),
                                      Text("${trip['car_no']}",
                                          style: VaayoTheme.mediumBold),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(((List.from(trip['passengers'])).isEmpty)
                                  ? ""
                                  : "   Passengers"),
                              Column(
                                children: [
                                  Text(
                                      "${List.from(trip['passengers']).length}/${trip['available_seats']}",
                                      style: VaayoTheme.mediumBold),
                                  const Icon(Icons.person),
                                ],
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: passengers.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: null,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 3),
                                            child: Card(
                                              elevation: 50,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            '${passengers[index]['name']},\t\t\t${passengers[index]['age']}'),
                                                        (passengers[index][
                                                                    'gender'] ==
                                                                'M')
                                                            ? const Icon(
                                                                Icons.male,
                                                                color:
                                                                    Colors.blue,
                                                              )
                                                            : const Icon(
                                                                Icons.female,
                                                                color: Colors
                                                                    .pink),
                                                        Text(
                                                          '${trip['passengers'][index]['status']}',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        if ((uid ==
                                                                trip['passengers']
                                                                        [index]
                                                                    ['uid']) &&
                                                            (trip['status'] !=
                                                                'CREATED') &&
                                                            (trip['passengers']
                                                                        [index][
                                                                    'status'] ==
                                                                'BOOKED'))
                                                          ElevatedButton(
                                                              onPressed: () =>
                                                                  _setBoardedStatus(
                                                                      index),
                                                              child: const Text(
                                                                  'BOARD')),
                                                        ElevatedButton(
                                                            onPressed: () =>
                                                                _callPhone(
                                                                    passengers[
                                                                            index]
                                                                        [
                                                                        'phone']),
                                                            child: const Text(
                                                                'CALL')),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, bottom: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Cancel Booking"),
                                content: const Text(
                                    "Are you sure you want to Cancel this Ride?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      //DELETE TRIP CODE
                                      _cancelRide();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      navKey.currentState?.pushNamed("Home");
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("CANCEL RIDE")),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _cancelRide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    (trip['passengers'] as List)
        .removeWhere((element) => (element['uid'] == uid));
    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(trip['id'])
          .update(trip);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void _getPassengerDetails() async {
    try {
      for (Map<String, dynamic> passenger in trip['passengers']) {
        String uid = passenger['uid'];
        DocumentSnapshot documentSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (documentSnapshot.exists) {
          passengers.add(documentSnapshot.data() as Map<String, dynamic>);
        }
      }
      setState(() {});
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    } //GETLOCATION
    if (trip['status'] == 'WAITING' || trip['status'] == 'STARTED') {
      _getLocations();
    }
  }

  void _getUID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString('uid');
  }

  void _setBoardedStatus(int index) async {
    trip['passengers'][index]['status'] = 'BOARDED';
    setState(() {});
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(trip['id'])
        .update(trip);
  }

  void _callPhone(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: "+91$phone");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _getLocations() async {
    userLocation = await _getuserLocation();
    sourceLocation = await _getLocationCoordinates(address: trip['departure']);
    destinationLocation =
        await _getLocationCoordinates(address: trip['destination']);
    if (trip['status'] == 'WAITING') {
      _routePolyLinePoints =
          await _getPolyLineRoute(start: userLocation, end: sourceLocation);
    } else if (trip['status'] == 'STARTED') {
      _routePolyLinePoints = await _getPolyLineRoute(
          start: sourceLocation, end: destinationLocation);
    }
    setState(() => _isLoading = false);
  }

  Future<LatLng> _getuserLocation() async {
    LocationData? userLocationData;
    Location location = Location();
    await location.getLocation().then((value) => userLocationData = value);
    LatLng loc = LatLng(
        userLocationData!.latitude ?? 0, userLocationData!.longitude ?? 0);
    location.onLocationChanged.listen((newLocData) {
      setState(() {
        userLocation =
            LatLng(newLocData.latitude ?? 0, newLocData.longitude ?? 0);
      });
    });
    return loc;
  }

  Future<LatLng> _getLocationCoordinates({required String address}) async {
    final Uri request = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$vaayoMapsAPIKey");
    var response = await http.get(request);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      var loc = decodedResponse['results'][0]['geometry']['location']
          as Map<String, dynamic>;
      return LatLng(loc['lat'], loc['lng']);
    }
    return Future.error(response);
  }

  Future<List<LatLng>> _getPolyLineRoute(
      {required LatLng? start, required LatLng? end}) async {
    final List<LatLng> pointList = [];
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        vaayoMapsAPIKey,
        PointLatLng(start!.latitude, start.longitude),
        PointLatLng(end!.latitude, end.longitude));
    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        pointList.add(LatLng(point.latitude, point.longitude));
      }
    }
    return pointList;
  }
}
