import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'package:vaayo/src/constants/theme.dart';

class TripDetailsPage extends StatefulWidget {
  const TripDetailsPage({super.key});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  Map<String, dynamic> trip = {
    // 'departure_time': Timestamp.now(),
    // 'status': 'CREATED',
    // 'total_seats': 3,
    // 'id': 'CkwnJWIrDttowxMhyvsz',
    // 'departure': 'Sample Data:PLeasae remove',
    // 'destination': ' Cheruthoni,Kerala, India',
    // 'available_seats': 3,
    // 'driver_uid': 'b9vDMSNhYjQXRndiJCequ1pviH82',
    // 'passengers': ['zqMqFXzEguPEtnSChHf4Z1XLaMB2'],
    // 'car_no': 'KL21K2222'
  };
  List<Map<String, dynamic>> passengers = [
    // {
    // 'age': 21,
    // ' cars': [
    //   {'no': ' KL 17 N 6665', 'model': 'Celerio'}
    // ],
    // 'bio': ' Btech student',
    // 'phone': "7736110274",
    // 'tags': [],
    // 'name': 'Anandu',
    // 'gender': 'M',
    // 'email': 'anandudina2003@gmail.com'
    // }
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trip = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _getPassengerDetails();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = (trip['departure_time'] as Timestamp).toDate();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Trip Details"),
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
              const Row(
                  //MAP
                  children: []),
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
                            padding: EdgeInsets.all(15.0),
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
                            "${date.day} ${date.toMonth()} ${date.year}\n   ${date.hour % 12}:${(date.minute == 0) ? '00' : date.minute} ${date.hour > 12 ? "AM" : "PM"}",
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
                                    physics: NeverScrollableScrollPhysics(),
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
                                                            ? Icon(
                                                                Icons.male,
                                                                color:
                                                                    Colors.blue,
                                                              )
                                                            : Icon(Icons.female,
                                                                color:
                                                                    Colors.pink)
                                                      ],
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () =>
                                                            _callPhone(
                                                                passengers[
                                                                        index]
                                                                    ['phone']),
                                                        child: Text('CALL'))
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
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this trip?"),
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
                                      _deleteTrip();
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

  void _deleteTrip() async {
    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(trip['id'])
          .delete();
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
      setState(() {});
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void _callPhone(String phone) async {
    final Uri _url = Uri(scheme: 'tel', path: "+91$phone");
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
