import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:vaayo/main.dart';
import 'package:vaayo/src/constants/keys.dart';

class VaayoLocationInput extends StatefulWidget {
  const VaayoLocationInput({
    super.key,
  });
  @override
  State<VaayoLocationInput> createState() => VaayoLocationInputState();
}

class VaayoLocationInputState extends State<VaayoLocationInput> {
  GooglePlace googlePlace = GooglePlace(vaayoMapsAPIKey);
  var uuid = const Uuid();
  String sessionToken = "1234456";
  List<String> predictions = [];
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return [];
        } else {
          getPredictions(input: textEditingValue.text, outputList: predictions);
          return predictions;
        }
      },
    );
  }

  void getPredictions({required String? input, required outputList}) async {
    //GET PREDICTIONS
    if (sessionToken == null) {
      navKey.currentState?.setState(() {
        sessionToken = uuid.v4();
      });
    }
    outputList = [];
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input="$input"&key=$vaayoMapsAPIKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      for (int i = 0; i < decodedResponse['predictions'].length; i++) {
        outputList
            .add(decodedResponse['predictions'][i]['description'].toString());
      }
      navKey.currentState?.setState(() {});
    }
  }
}
