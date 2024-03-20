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

//
class RideDetailsPage extends StatelessWidget {
  const RideDetailsPage({super.key, required this.rideId});
  final int? rideId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ride Details"),
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
              Text("   Driver deattils"),
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
