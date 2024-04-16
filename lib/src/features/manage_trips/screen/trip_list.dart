import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  var _trips = [];
  int _noOfTrips = 0;

  @override
  void initState() {
    _getTripData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("MY TRIPS"),
        ),
        body: ListView.builder(
          itemCount: _noOfTrips + 1,
          itemBuilder: (context, index) {
            if (index == _noOfTrips) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  onTap: () => navKey.currentState?.pushNamed("CreateTrips"),
                  child: const Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 50,
                        ),
                        Text("Schedule a Trip")
                      ],
                    ),
                  )),
                ),
              );
            } else {
              DateTime date =
                  (_trips[index]['departure_time'] as Timestamp).toDate();
              return InkWell(
                onTap: () {
                  navKey.currentState?.pushNamed("RideDetails", arguments: 2);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    child: SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // LOCATION
                                  "${_trips[index]['departure']}  ->\n${_trips[index]['destination']}",
                                  overflow: TextOverflow.visible,
                                ),
                                Text(
                                  // TIME
                                  "${date.day} ${date.toMonth()} ${date.year}   ${date.hour % 12} :${date.minute} ${date.hour < 12 ? 'AM' : 'PM'}",
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              "${_trips[index]['total_seats'] - _trips[index]['available_seats']}/${_trips[index]['total_seats']}"),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 3)),
                                          const Icon(Icons.person)
                                        ],
                                      ),
                                      Text(
                                        // RIDE STATUS
                                        "${_trips[index]['status']}",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${_trips[index]['car_no']}",
                                      style: const TextStyle(fontSize: 20)),
                                  const CircleAvatar(
                                      radius: 35, child: Placeholder()),
                                  Text("DriverName$index")
                                ],
                              ),
                            )
                          ]),
                        )),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _getTripData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection('trips')
        .where('driver_uid', isEqualTo: prefs.getString('uid'))
        .where('status', isEqualTo: 'created')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _trips = List<Map<String, dynamic>>.from(
            querySnapshot.docs.map((doc) => doc.data()).toList());
        _noOfTrips = _trips.length;
      });
    });
  }
}
