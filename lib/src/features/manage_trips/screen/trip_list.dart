import 'package:flutter/material.dart';
import 'package:vaayo/main.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final int _noOfRides = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("MY TRIPS"),
        ),
        body: ListView.builder(
          itemCount: _noOfRides + 1,
          itemBuilder: (context, index) {
            if (index == _noOfRides) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  onTap: () => navKey.currentState?.pushNamed("CreateTrips"),
                  child: const Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 50,
                        ),
                        Text("Schedule a Trip")
                      ],
                    ),
                  )),
                ),
              );
            } else {
              return InkWell(
                onTap: () {
                  navKey.currentState?.pushNamed("RideDetails", arguments: 2);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    child: SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(// LOCATION
                                    "startlocation $index ---> Endlocation$index"),
                                Text(
                                  // TIME
                                  "$index:00",
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("$index/4"),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 3)),
                                          const Icon(Icons.person)
                                        ],
                                      ),
                                      Text(
                                        // RIDE STATUS
                                        "status$index",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("KL2012$index",
                                      style: const TextStyle(fontSize: 20)),
                                  const CircleAvatar(
                                      radius: 35, child: Placeholder()),
                                  Text("DriverName$index")
                                ],
                              ),
                            )
                          ]),
                        )),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
