import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  List<String> predictions = [];
  String? depature, destination;
  List<Map<String, dynamic>> _rides = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "SEARCH RIDES",
            style: VaayoTheme.mediumBold,
          ),
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
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3 - 20,
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
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _rides.length,
                        itemBuilder: (context, index) {
                          DateTime date =
                              (_rides[index]['departure_time'] as Timestamp)
                                  .toDate();
                          return InkWell(
                            onTap: () {
                              navKey.currentState?.pushNamed("BookRides",
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
    try {
      if (depature == null || destination == null) {
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      await FirebaseFirestore.instance
          .collection('trips')
          .where('status', isEqualTo: 'CREATED')
          .where('destination', isEqualTo: destination)
          .where('departure', isEqualTo: depature)
          .where('driver_uid', isNotEqualTo: uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        _rides = List<Map<String, dynamic>>.from(
            querySnapshot.docs.map((doc) => doc.data()).toList());
        _rides.removeWhere(
          (element) => List.from(element['passengers']).contains(uid),
        );
        setState(() {});
      });
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
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
