import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  late Map<String, dynamic> trip = {
    //SAMPLE DATA FOR DEBUGGING PURPOSE
    "available_seats": 3,
    "passengers": [],
    "total_seats": 3,
    'departure_time': Timestamp.now(),
    "departure": 'Painavu,Kerala,India',
    'driver_uid': 'fURKV6hSATR1RiXdIfKZqSTv8wA2',
    'destination': 'Cheruthoni, Kerala, India',
    'car_no': 'KL47C7993',
    'car_model': 'Toyota Supra',
    'status': 'CREATED'
  };
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //TODO: trip = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    debugPrint(trip.toString());
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
                          Expanded(
                            child: Text(
                              trip['departure'],
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 50,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              trip['destination'],
                              maxLines: 2,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          //TIME
                          Text(
                            "${date.day} ${date.toMonth()} ${date.year}\n   ${date.hour % 12} ${date.minute} ${date.hour > 12 ? "AM" : "PM"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: .5,
                          ),
                          Text(trip['status'],
                              style:
                                  TextStyle(fontSize: 20, color: Colors.green)),
                          Text(
                              "${List.from(trip['passengers']).length}/${trip['available_seats']}",
                              style: TextStyle(fontSize: 30)),
                          Icon(Icons.person)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Text(((List.from(trip['passengers'])).isEmpty)
                  ? ""
                  : "   Passengers"),
              // ListView.builder(
              //   itemBuilder: (context, index) {return },
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, bottom: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text("CANCEL RIDE")),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
