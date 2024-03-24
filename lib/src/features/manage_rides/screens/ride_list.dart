import 'package:flutter/material.dart';
import 'package:vaayo/main.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  final int _noOfRides = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("My Rides"),
        ),
        body: ListView.builder(
          itemCount: _noOfRides + 1,
          itemBuilder: (context, index) {
            if (index == _noOfRides) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  onTap: () => navKey.currentState?.pushNamed("SearchRides"),
                  child: const Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 50,
                        ),
                        Text("Search and add new Ride")
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
                                Text(
                                  "Pick Offf POint:$index",
                                  style: const TextStyle(fontSize: 20),
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
