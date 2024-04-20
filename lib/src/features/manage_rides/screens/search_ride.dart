import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'package:vaayo/src/constants/keys.dart';
import 'package:vaayo/src/constants/theme.dart';

class SearchRidesPage extends StatefulWidget {
  const SearchRidesPage({super.key});

  @override
  State<SearchRidesPage> createState() => _SearchRidesPageState();
}

class _SearchRidesPageState extends State<SearchRidesPage> {
  GooglePlace googlePlace = GooglePlace(vaayoMapsAPIKey);
  List<String> predictions = [];
  String? depature, destination;
  List<Map<String, dynamic>> _rides = [
    {
      //SAMPLE DATA FOR DEBUGGING PURPOSE
      'id': "hUxdjdFTzJtTNb6yj1s2",
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
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SEARCH RIDES"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Card(
                elevation: 20,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3 - 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("From"),
                        Autocomplete<String>(
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return [];
                            } else {
                              _getPredictions(textEditingValue.text);
                              return predictions;
                            }
                          },
                          onSelected: (option) {
                            depature = option;
                          },
                        ),
                        const Text("To"),
                        Autocomplete<String>(
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return [];
                            } else {
                              _getPredictions(textEditingValue.text);
                              return predictions;
                            }
                          },
                          onSelected: (option) {
                            destination = option;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _getRidesData();
                            },
                            child: const Text("Search")),
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _rides.length,
                        itemBuilder: (context, index) {
                          DateTime date =
                              (_rides[index]['departure_time'] as Timestamp)
                                  .toDate();
                          return InkWell(
                            onTap: () {
                              navKey.currentState?.pushNamed("TripDetails",
                                  arguments: _rides[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Card(
                                child: SizedBox(
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(// LOCATION
                                                "${_rides[index]['departure']} ->\n${_rides[index]['destination']}"),
                                            Text(
                                              "${date.day} ${date.toMonth()} ${date.year}    ${date.hour % 12}: ${(date.minute == 0) ? '00' : date.minute} ${date.hour > 12 ? "AM" : "PM"}",
                                              textAlign: TextAlign.center,
                                              style: VaayoTheme.mediumBold,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "${List.from(_rides[index]['passengers']).length}/${_rides[index]['available_seats']}",
                                                    style:
                                                        VaayoTheme.mediumBold),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 3)),
                                                const Icon(Icons.person)
                                              ],
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text("${_rides[index]['car_no']}",
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                              const CircleAvatar(
                                                  radius: 35,
                                                  child: Placeholder()),
                                              Text("DriverName$index")
                                            ],
                                          ),
                                        )
                                      ]),
                                    )),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _getRidesData() async {
    if (depature == null || destination == null) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('trips')
        .where('status', isEqualTo: 'CREATED')
        .where('destination', isEqualTo: destination)
        .where('departure', isEqualTo: depature)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _rides = List<Map<String, dynamic>>.from(
            querySnapshot.docs.map((doc) => doc.data()).toList());
      });
    });
  }

  void _getPredictions(String? input) async {
    predictions = [];
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input="$input"&key=$vaayoMapsAPIKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      for (int i = 0; i < decodedResponse['predictions'].length; i++) {
        predictions
            .add(decodedResponse['predictions'][i]['description'].toString());
      }
      setState(() {});
    }
  }
}
