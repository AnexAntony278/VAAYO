import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:vaayo/src/constants/keys.dart';

class SearchRidesPage extends StatefulWidget {
  const SearchRidesPage({super.key});

  @override
  State<SearchRidesPage> createState() => _SearchRidesPageState();
}

class _SearchRidesPageState extends State<SearchRidesPage> {
  GooglePlace googlePlace = GooglePlace(vaayoMapsAPIKey);
  var uuid = Uuid();
  String sessionToken = "1234456";
  List<String> predictions = [];
  String? depature, destination;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          child: Column(
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
              ElevatedButton(
                  onPressed: () {
                    debugPrint("$depature to $destination");
                  },
                  child: const Text("Search"))
              // TextFormField(
              //   controller: _departureTextController,
              //   decoration:
              //       const InputDecoration(hintText: "departure location"),
              //   onChanged: (value) {
              //     _getPredictions(value);
              //   },
              // ),
              // Expanded(
              //     child: ListView.builder(
              //   itemCount: predictions.length,
              //   itemBuilder: (context, index) {
              //     return ListTile(
              //         onTap: () =>
              //             _departureTextController.text = predictions[index],
              //         tileColor: Colors.blueGrey,
              //         style: ListTileStyle.list,
              //         title: Text(predictions[index]));
              //   },
              // )),
            ],
          ),
        ));
  }

  void _getPredictions(String? input) async {
    //GET PREDICTIONS
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
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
