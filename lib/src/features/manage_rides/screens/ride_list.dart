import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'package:vaayo/src/constants/theme.dart';

class RidesPage extends StatefulWidget {
  const RidesPage({super.key});

  @override
  State<RidesPage> createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> {
  final List<Map<String, dynamic>> _rides = [];
  final List<Map<String, dynamic>> _drivers = [];
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
          title: const Text(
            "My Rides",
            style: VaayoTheme.mediumBold,
          ),
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
                  navKey.currentState?.pushNamed("RideDetails",
                      arguments: [_rides[index], _drivers[index]]);
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
                                    "${_rides[index]['departure']}->\n${_rides[index]['destination']}"),
                                Text(
                                  "${date.day} ${date.toMonth()} ${date.year}  ${date.hour % 12} :${date.minute} ${(date.hour > 12) ? (date.hour == 24) ? 'AM' : 'PM' : "AM"}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${_rides[index]['car_no']}",
                                      style: VaayoTheme.mediumBold),
                                  const CircleAvatar(
                                      radius: 35, child: Placeholder()),
                                  Text(
                                    "${_drivers[index]['name']}",
                                    style: VaayoTheme.mediumBold,
                                  )
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
          .where('passengers',
              arrayContains: {'status': 'BOOKED', 'uid': uid}).get();
      for (var i in querySnapshot.docs) {
        if (i.exists) {
          _rides.add(i.data() as Map<String, dynamic>);
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_rides.last['driver_uid'])
            .get()
            .then((value) {
          _drivers.add(value.data() as Map<String, dynamic>);
        });
      }
      for (var ride in _rides) {
        if ((DateTime.now()
            .add(const Duration(hours: 2))
            .isAfter((ride['departure_time'] as Timestamp).toDate()))) {
          ride['status'] = 'WAITING';
          updateTripStatus(trip: ride);
        }
      }
      if (mounted) {
        setState(() {});
      }
    } on FirebaseException catch (e) {
      debugPrint(e.code);
    }
  }

  void updateTripStatus({required Map<String, dynamic> trip}) async {
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(trip['id'])
        .update(trip);
  }
}
