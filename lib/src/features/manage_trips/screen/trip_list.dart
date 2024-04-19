import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    super.initState();
    _getTripData();
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
              List<String> departure =
                  (_trips[index]['departure'].contains('-'))
                      ? _trips[index]['departure'].split('- ')
                      : _trips[index]['departure'].split(', ');
              List<String> destination =
                  (_trips[index]['destination'].contains('-'))
                      ? _trips[index]['destination'].split('- ')
                      : _trips[index]['destination'].split(', ');
              return InkWell(
                onTap: () {
                  navKey.currentState
                      ?.pushNamed("TripDetails", arguments: _trips[index]);
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
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          // LOCATION
                                          "${departure[0]}\n${departure[1]}",
                                          textAlign: TextAlign.left),
                                      Text(
                                        // LOCATION
                                        "${destination[0]}\n${destination[1]}",
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    // TIME
                                    "${date.day} ${date.toMonth()} ${date.year}  \n ${date.hour} :${date.minute} ${date.hour > 12 ? "AM" : "PM"}",
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // RIDE STATUS
                                        "${_trips[index]['status']}",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
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
                                      Text("${_trips[index]['car_no']}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
        .where('status', isEqualTo: 'CREATED')
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
