import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'package:vaayo/src/constants/theme.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  List<Map<String, dynamic>> _trips = [];

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
          title: const Text(
            "MY TRIPS",
            style: VaayoTheme.mediumBold,
          ),
        ),
        body: ListView.builder(
          itemCount: _trips.length + 1,
          itemBuilder: (context, index) {
            if (index == _trips.length) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "${_trips[index]['departure']}",
                                          textAlign: TextAlign.left,
                                          softWrap: true,
                                          maxLines: 3,
                                          style: VaayoTheme.mediumBold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 150,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${_trips[index]['destination']}",
                                          textAlign: TextAlign.right,
                                          softWrap: true,
                                          maxLines: 3,
                                          style: VaayoTheme.mediumBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    // TIME
                                    "${date.day} ${date.toMonth()} ${date.year}  \n ${date.hour} :${date.minute} ${date.hour > 12 ? "AM" : "PM"}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
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
                                              "${List.from(_trips[index]['passengers']).length}/${_trips[index]['total_seats']}"),
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
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _trips = List<Map<String, dynamic>>.from(
            querySnapshot.docs.map((doc) => doc.data()).toList());
      });
    });
  }
}
