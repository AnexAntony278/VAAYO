import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({Key? key}) : super(key: key);

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _totalseats = 4;
  int? _availSeats = 3;
  String? _selectedCar;

  final List<String> _cars = ["anex"];

  final TextEditingController _departureFieldController =
      TextEditingController();
  final TextEditingController _destinationFieldController =
      TextEditingController();
  final TextEditingController _dateFieldController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCar = _cars[0];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("CREATE TRIPS"),
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
                      Text("From"),
                      TextField(
                        controller: _departureFieldController,
                        decoration: InputDecoration(
                          hintText: 'Enter departure location',
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("To"),
                      TextField(
                        controller: _destinationFieldController,
                        decoration: InputDecoration(
                          hintText: 'Enter destination location',
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: TextField(
                                controller: _dateFieldController,
                                decoration: InputDecoration(
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
                              decoration: InputDecoration(
                                  hintText: "Time",
                                  filled: true,
                                  prefixIcon: Icon(Icons.alarm)),
                              readOnly: true,
                              onTap: () => _showTimePicker(context),
                            ),
                          ),
                        ],
                      ),
                      Text("Available Seats"),
                      //SEATS DROPDOWN
                      DropdownButton<int>(
                        value: _availSeats,
                        onChanged: (value) {
                          _availSeats = value;
                          setState(() {});
                        },
                        items: List.generate(
                          _totalseats!,
                          (index) => DropdownMenuItem(
                            value: _totalseats! - index,
                            child: Text('${_totalseats! - index}'),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Placeholder(child: Text("TAGS")),
                      SizedBox(height: 10),
                      Text("Car select"),
                      //CARS DROPDOWN
                      DropdownButton<String>(
                          value: _selectedCar,
                          onChanged: (value) {
                            setState(() {
                              _selectedCar = value;
                            });
                          },
                          items: _cars.map((car) {
                            return DropdownMenuItem<String>(
                              value: car,
                              child: Text(car),
                            );
                          }).toList()),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                width: 10,
                child: ElevatedButton(
                  onPressed: () => _createTrip(),
                  child: Text("CREATE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//FUNCTIONS
  Future<void> _showDatePicker(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
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
    debugPrint(_selectedTime.toString());
  }

  void _createTrip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    debugPrint(_selectedDate.toString());
    _selectedDate!.add(
        Duration(hours: _selectedTime!.hour, minutes: _selectedTime!.minute));

    Map<String, dynamic> trip = {
      'driver_uid': uid,
      'departure': _departureFieldController.text,
      'destination': _destinationFieldController.text,
      'departure_time': _selectedDate.toString(),
      'available_seats': _availSeats,
    };
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Card(
              child: SizedBox(
                  height: 200,
                  width: 300,
                  child: Text("${trip.toString()} \n CREATED ")),
            ),
          );
        });
  }
}
