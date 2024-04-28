import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
        // SAMPLE DATA FOR DEBUGGING PURPOSE
        // 'id': "hUxdjdFTzJtTNb6yj1s2",
        // "available_seats": 3,
        // "passengers": [],
        // "total_seats": 3,
        // 'departure_time': Timestamp.now(),
        // 'driver_uid': 'fURKV6hSATR1RiXdIfKZqSTv8wA2',
        // 'destination': 'Cheruthoni, Kerala, India',
        // 'departure': 'Cheruthoni, Kerala, India',
        // 'car_no': 'KL47C7993',
        // 'status': 'CREATED'
      },
      driver = {
        // 'age': 21,
        // 'cars': [
        //   {'no': 'KL47C7993', 'model': 'Celerio'}
        // ],
        // 'bio': ' Btech student',
        // 'phone': "7736110274",
        // 'tags': [],
        // 'name': 'Anandu',
        // 'gender': 'M',
        // 'email': 'anandudina2003@gmail.com'
      };
  final List<Map<String, dynamic>> passengers = [
    {
      // 'age': 21,
      // 'cars': [
      //   {'no': ' KL 17 N 6665', 'model': 'Celerio'}
      // ],
      // 'bio': ' Btech student',
      // 'phone': "7736110274",
      // 'tags': [],
      // 'name': 'Anandu',
      // 'gender': 'M',
      // 'email': 'anandudina2003@gmail.com'
    }
  ];
  @override
  void initState() {
    super.initState();
    if ((trip['passengers'] as List).isNotEmpty &&
        trip['passengers'].length != passengers.length) {
      _getPassengerDetails();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trip = (ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>)[0];
    driver = (ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>)[1];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("$trip\n$passengers\n$driver\n");
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
              Builder(
                builder: (context) {
                  return (trip['status'] == 'CREATED')
                      ? const SizedBox(
                          height: 10,
                        )
                      : const Card(
                          child: SizedBox(
                            height: 400,
                          ),
                        );
                },
              ),
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

                          const Icon(Icons.person)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Text("   Driver details"),
              Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${trip['car_no']}",
                              style: VaayoTheme.largeBold),
                          Text(
                            "${(driver['cars'] as List).where((car) => car['no'] == trip['car_no']).first['model']}",
                            style: VaayoTheme.mediumBold,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () => _callPhone(driver['phone']),
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
                          const CircleAvatar(radius: 40, child: Placeholder()),
                          Text("${driver['name']}",
                              style: VaayoTheme.mediumBold),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Text((passengers.isEmpty) ? "" : "\t\t  Passenger Details"),
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: passengers.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                child: Card(
                                  elevation: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${passengers[index]['name']},\t\t\t${passengers[index]['age']}'),
                                            (passengers[index]['gender'] == 'M')
                                                ? const Icon(
                                                    Icons.male,
                                                    color: Colors.blue,
                                                  )
                                                : const Icon(Icons.female,
                                                    color: Colors.pink)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        })
                  ],
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

  void _getPassengerDetails() async {
    try {
      for (String passengerId in trip['passengers']) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(passengerId)
            .get();
        if (documentSnapshot.exists) {
          passengers.add(documentSnapshot.data() as Map<String, dynamic>);
        }
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void _callPhone(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: "+91$phone");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
