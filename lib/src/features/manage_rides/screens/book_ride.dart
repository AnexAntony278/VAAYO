import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'package:vaayo/src/constants/theme.dart';

class BookRidePage extends StatefulWidget {
  const BookRidePage({super.key});

  @override
  State<BookRidePage> createState() => _BookRidePageState();
}

class _BookRidePageState extends State<BookRidePage> {
  Map<String, dynamic>? ride = {
    //SAMPLE DATA FOR DEBUGGING PURPOSE
    // 'id': "hUxdjdFTzJtTNb6yj1s2",
    // "available_seats": 3,
    // "passengers": [],
    // "total_seats": 3,
    // 'departure_time': Timestamp.now(),
    // "departure": 'Painavu,Kerala,India',
    // 'driver_uid': 'fURKV6hSATR1RiXdIfKZqSTv8wA2',
    // 'destination': 'Cheruthoni, Kerala, India',
    // 'car_no': 'KL47C7993',
    // 'car_model': 'Toyota Supra',
    // 'status': 'CREATED'
  };
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ride = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>; //TODO:REMOVE
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = (ride!['departure_time'] as Timestamp).toDate();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Book Ride"),
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
              Row(
                  //MAP
                  children: []),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              ride!['departure'],
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              style: VaayoTheme.largeBold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 45,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              ride!['destination'],
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
                            "${date.day} ${date.toMonth()} ${date.year}\n   ${date.hour % 12}:${(date.minute == 0) ? '00' : date.minute} ${date.hour > 12 ? "AM" : "PM"}",
                            textAlign: TextAlign.center,
                            style: VaayoTheme.mediumBold,
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: .5,
                          ),
                          Text(ride!['status'],
                              style:
                                  TextStyle(fontSize: 20, color: Colors.green)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(((List.from(ride!['passengers'])).isEmpty)
                                  ? ""
                                  : "   Passengers"),
                              Column(
                                children: [
                                  Text(
                                      "${List.from(ride!['passengers']).length}/${ride!['available_seats']}",
                                      style: VaayoTheme.mediumBold),
                                  const Icon(Icons.person),
                                ],
                              ),
                            ],
                          )
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
                                title: const Text("Confirm Booking"),
                                content: const Text(
                                    "Are you sure you want to Book this trip?"),
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
                                      _bookTrip();
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
                        child: const Text("BOOK RIDE")),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _bookTrip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    (ride!['passengers'] as List).add(uid);
    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(ride!['id'])
          .update(ride as Map<String, dynamic>);
      debugPrint(ride.toString());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }
}
