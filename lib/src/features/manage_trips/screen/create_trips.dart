import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';
import 'dart:convert';
import 'package:google_place/google_place.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:vaayo/src/constants/keys.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({Key? key}) : super(key: key);

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final int? _totalseats = 4;
  int? _availSeats = 3;

  List<Map<String, dynamic>> _cars = [];
  Map<String, dynamic>? _selectedCar;

  //AUTOCOMPLETE
  GooglePlace googlePlace = GooglePlace(vaayoMapsAPIKey);
  var uuid = const Uuid();
  String sessionToken = "1234456";
  List<String> predictions = [];
  String? _departure, _destination;
  final TextEditingController _dateFieldController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? _message;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text("CREATE TRIPS"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                          _departure = option;
                        },
                      ),
                      const SizedBox(height: 10),
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
                          _destination = option;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: TextField(
                                controller: _dateFieldController,
                                decoration: const InputDecoration(
                                    filled: true,
                                    hintText: "Date",
                                    prefixIcon: Icon(Icons.date_range)),
                                readOnly: true,
                                onTap: () {
                                  _showDatePicker(context);
                                }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 80,
                            child: TextField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                  hintText: "Time",
                                  filled: true,
                                  prefixIcon: Icon(Icons.alarm)),
                              readOnly: true,
                              onTap: () => _showTimePicker(context),
                            ),
                          ),
                        ],
                      ),
                      const Text("Available Seats"),
                      //SEATS DROPDOWN
                      DropdownButton<int>(
                        value: _availSeats,
                        onChanged: (value) {
                          setState(() {
                            _availSeats = value;
                          });
                        },
                        items: List.generate(
                          _totalseats!,
                          (index) => DropdownMenuItem(
                            value: _totalseats - index,
                            child: Text('${_totalseats - index}'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Placeholder(child: Text("TAGS")),
                      const SizedBox(height: 10),
                      const Text("Car select"),
                      //CARS DROPDOWN
                      DropdownButton<Map<String, dynamic>>(
                          value: _selectedCar,
                          onChanged: (value) {
                            setState(() {
                              _selectedCar = value;
                            });
                          },
                          items: _cars.map((car) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: car,
                              child: Text("${car['no']}-${car['model']} "),
                            );
                          }).toList()),
                      Text(
                        _message ?? "",
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                width: 10,
                child: ElevatedButton(
                  onPressed: () => _createTrip(),
                  child: const Text("CREATE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//FUNCTIONS
  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then(
      (documentSnapshot) {
        _cars =
            List<Map<String, dynamic>>.from(documentSnapshot.data()?['cars']);
        setState(() {});
      },
    );
    if (_cars.isEmpty) {
      _message = "No Car Added. Got to Profile Page ";
    } else {
      _selectedCar = _cars[0];
    }
  }

  Future<void> _showDatePicker(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _dateFieldController.text =
          "${_selectedDate!.day} ${_selectedDate!.toMonth()} ${_selectedDate!.year}, ${_selectedDate!.toWeekday()} ";
    }
  }

  Future<void> _showTimePicker(context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      _selectedTime = pickedTime;
      _timeController.text =
          "${_selectedTime!.hour % 12} : ${_selectedTime!.minute} ${(_selectedTime!.hour < 12) ? "AM" : "PM"} ";
    }
  }

  void _createTrip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    DateTime tripDateTime = _selectedDate!.add(Duration(
      hours: _selectedTime!.hour,
      minutes: _selectedTime!.minute,
    ));

    Map<String, dynamic> trip = {
      'driver_uid': uid,
      'departure': _departure,
      'destination': _destination,
      'departure_time': Timestamp.fromDate(tripDateTime),
      'available_seats': _availSeats,
      'total_seats': _availSeats,
      'passenegers': [],
      'car_no': _selectedCar?['no'].toString() ?? '',
      'car_model': _selectedCar?['model'].toString() ?? '',
      'status': "CREATED"
    };

    DocumentReference _docRef =
        await FirebaseFirestore.instance.collection("trips").add(trip);
    trip['id'] = _docRef.id;
    _docRef.update(trip);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Trip created successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                navKey.currentState?.pushNamed("Home");
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _getPredictions(String? input) async {
    //GET PREDICTIONS
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
