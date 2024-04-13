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

  final List<String> _cars = ["toyota supra", "ford mustang", "chevyy"];

  final TextEditingController _departureFieldController =
      TextEditingController();
  final TextEditingController _destinationFieldController =
      TextEditingController();
  final TextEditingController _dateFieldController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<String> predictions = [];

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
                      TextField(
                        controller: _departureFieldController,
                        onChanged: (value) => _onDepartureFieldChanged(value),
                        decoration: const InputDecoration(
                          hintText: 'Enter departure location',
                          filled: true,
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Text("To"),
                      TextField(
                        controller: _destinationFieldController,
                        decoration: const InputDecoration(
                          hintText: 'Enter destination location',
                          filled: true,
                        ),
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
                      const SizedBox(height: 10),
                      const Placeholder(child: Text("TAGS")),
                      const SizedBox(height: 10),
                      const Text("Car select"),
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

  void _onDepartureFieldChanged(String? input) async {
    if (input!.isNotEmpty) {}
  }
}
