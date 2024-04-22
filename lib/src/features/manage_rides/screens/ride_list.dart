import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';

class RidesPage extends StatefulWidget {
  const RidesPage({super.key});

  @override
  State<RidesPage> createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> {
  final List<Map<String, dynamic>> _rides = [];
  @override
  void initState() {
    super.initState();
    _getRides();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("My Rides"),
        ),
        body: ListView.builder(
          itemCount: _rides.length + 1,
          itemBuilder: (context, index) {
            if (index == _rides.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  onTap: () => navKey.currentState?.pushNamed("SearchRides"),
                  child: const Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 50,
                        ),
                        Text("Search and add new Ride")
                      ],
                    ),
                  )),
                ),
              );
            } else {
              DateTime date =
                  (_rides[index]['departure_time'] as Timestamp).toDate();
              return InkWell(
                onTap: () {
                  navKey.currentState
                      ?.pushNamed("RideDetails", arguments: _rides[index]);
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
                                Text(// LOCATION
                                    "${_rides[index]['departure']}-> ${_rides[index]['destination']}"),
                                Text(
                                  // TIME
                                  "${date.day} ${date.toMonth()} ${date.year}  ${date.hour} :${date.minute} ${date.hour > 12 ? "AM" : "PM"}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                // Text(
                                //   "Pick UP POint:$index",
                                //   style: const TextStyle(fontSize: 20),
                                // ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              "${List.from(_rides[index]['passengers']).length}/${_rides[index]['total_seats']}"),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 3)),
                                          const Icon(Icons.person)
                                        ],
                                      ),
                                      Text(
                                        // RIDE STATUS
                                        "${_rides[index]['status']}",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
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
                                  Text("${_rides[index]['car_no']}",
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

  void _getRides() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .where('passengers', arrayContains: uid)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        _rides.add(querySnapshot.docs[i].data() as Map<String, dynamic>);
      }
      setState(() {});
    } on FirebaseException catch (e) {
      debugPrint(e.code);
    }
  }
}
