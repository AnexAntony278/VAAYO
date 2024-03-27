import 'package:flutter/material.dart';
import 'package:vaayo/src/utils/theme/widget_themes/elevated_button_theme.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From"),
                      Placeholder(
                        child: Text("SearchBox"),
                      ),
                      Text("To"),
                      Placeholder(
                        child: Text("SearchBox"),
                      ),
                      Placeholder(child: Text("DateTime Selelct")),
                      Placeholder(
                        child: Text("Available Seats"),
                      ),
                      Placeholder(
                        child: Text("TAGS"),
                      ),
                      Placeholder(
                        child: Text("Car select"),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text("CREATE")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
