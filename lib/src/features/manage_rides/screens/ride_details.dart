import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'package:vaayo/src/constants/theme.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage({super.key});

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  Map<String, dynamic> trip = {
    //SAMPLE DATA FOR DEBUGGING PURPOSE
    // 'id': "hUxdjdFTzJtTNb6yj1s2",
    // "available_seats": 3,
    // "passengers": [],
    // "total_seats": 3,
    // 'departure_time': Timestamp.now(),
    // 'driver_uid': 'fURKV6hSATR1RiXdIfKZqSTv8wA2',
    // 'destination': 'Cheruthoni, Kerala, India',
    // 'departure': 'Cheruthoni, Kerala, India',
    // 'car_no': 'KL47C7993',
    // 'car_model': 'Toyota Supra',
    // 'status': 'CREATED'
  };
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trip = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = (trip['departure_time'] as Timestamp).toDate();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ride Details"),
          actions: const [
            Icon(
              (Icons.emoji_transportation),
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
              const Row(
                  //MAP
                  children: []),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              " ${trip['departure']}",
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 50,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${trip['destination']}",
                              maxLines: 2,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          //TIME
                          Text(
                            "${date.day} ${date.toMonth()} ${date.year}\n   ${date.hour % 12}:${(date.minute == 0) ? '00' : date.minute} ${date.hour > 12 ? "AM" : "PM"}",
                            textAlign: TextAlign.center,
                            style: VaayoTheme.mediumBold,
                          ),
                          //PICKUPPOINT
                          // Text(
                          //   "PICKUPOINT",
                          //   style: TextStyle(fontSize: 30),
                          // ),
                          const Divider(
                            color: Colors.black,
                            thickness: .5,
                          ),
                          Text(trip['status'],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.green)),
                          Text(
                              "${List.from(trip['passengers']).length}/${trip['available_seats']}",
                              style: VaayoTheme.mediumBold),

                          Icon(Icons.person)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Text("   Driver details"),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("${trip['car_no']}",
                              style: TextStyle(fontSize: 30)),
                          Text("${trip['car_model']}"),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(radius: 40, child: Placeholder()),
                          Text("DriverName", style: TextStyle(fontSize: 25)),
                        ],
                      )
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
                                    "Are you sure you want to Cancel this Booking?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      //BOOK TRIP CODE
                                      _cancelRide();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      navKey.currentState?.pushNamed("Home");
                                    },
                                    child: const Text("Confirm"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("CANCEL")),
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
    (trip['passengers'] as List).removeWhere((element) => (element == uid));
    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(trip['id'])
          .update(trip);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }
}
