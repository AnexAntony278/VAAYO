import 'package:flutter/material.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage({super.key});

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  Map<String, dynamic> ride = {
    "start": "",
    "time": DateTime,
    "available_seats": 2,
    "total_seats": 3
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ride Details"),
          actions: const [
            Icon(
              (Icons.emoji_transportation),
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
            children: const [
              Row(
                  //MAP
                  children: []),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              " START\n DESTINATION",
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 50,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              " PAINAVUU\n,IDUKKI,KOAIISAJS ",
                              maxLines: 2,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          //TIME
                          Text(
                            "11:00 P  M",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 30),
                          ),
                          //PICKUPPOINT
                          Text(
                            "PICKUPOINT",
                            style: TextStyle(fontSize: 30),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: .5,
                          ),
                          Text("STATUS", style: TextStyle(fontSize: 20)),
                          Text("4/4", style: TextStyle(fontSize: 30)),
                          Icon(Icons.person)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Text("   Driver details"),
              InkWell(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("KL2012", style: TextStyle(fontSize: 30)),
                            Text("CAR TYPE"),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(radius: 40, child: Placeholder()),
                            Text("DriverName", style: TextStyle(fontSize: 25))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, bottom: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: null, child: Text("CANCEL")),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
