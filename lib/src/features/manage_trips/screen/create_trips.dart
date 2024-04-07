import 'package:flutter/material.dart';
import 'package:vaayo/src/common_widgets/custom_extensions.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({Key? key}) : super(key: key);

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  int? _totalseats = 4;
  int? _availSeats = 3;
  String? _selectedCar;

  final List<String> _cars = ["anex"];

  TextEditingController _dateFieldController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

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
                        decoration: InputDecoration(
                          hintText: 'Enter departure location',
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("To"),
                      TextField(
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
                  onPressed: () => _onCreateButtonClick,
                  child: Text("CREATE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    final TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_pickedTime != null && _pickedTime != _selectedTime) {
      _timeController.text =
          "${_selectedTime!.hour} : ${_selectedTime!.minute} ";
    }
  }

  Future<void> _onCreateButtonClick() async {
    _selectedDate!.add(
        Duration(hours: _selectedTime!.hour, minutes: _selectedTime!.minute));
  }
}
