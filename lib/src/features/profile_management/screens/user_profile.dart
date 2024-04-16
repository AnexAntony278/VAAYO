import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/src/common_widgets/widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final db = FirebaseFirestore.instance;
  Map<String, dynamic>? user;
  late DocumentSnapshot<Map<String, dynamic>> _snapshot;
  String? uid = "";

  @override
  void initState() {
    super.initState();
    _getUSerData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MY PROFILE"),
          actions: const [
            Icon(
              (Icons.supervised_user_circle),
              size: 40,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi There,\n${user?["name"] ?? ''},\n",
                          style: const TextStyle(fontSize: 30),
                        ),
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 6,
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        TextDataBox(
                          text: "age",
                          data: user?["age"]?.toString() ?? '',
                          noOfBox: 2,
                        ),
                        TextDataBox(
                          text: "gender",
                          data: user?["gender"] ?? '',
                          noOfBox: 2,
                        ),
                        TextDataBox(
                            text: "email",
                            data: user?["email"] ?? '',
                            noOfBox: 1),
                        TextDataBox(
                            text: "Phone.no",
                            data: user?['phone'] ?? '',
                            noOfBox: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "    Bio",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                            alignment: WrapAlignment.start,
                                            spacing: 5,
                                            children: List.generate(
                                                user?['tags']?.length ?? 0,
                                                (index) => Chip(
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                    label: Text(
                                                      '# ${user!['tags']![index]}',
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    )))),
                                        Text(user?['bio'] ?? ''),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            //RIDES
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "MY RIDES",
                            style: TextStyle(fontSize: 20),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final CarNoTextController =
                                            TextEditingController(),
                                        CarModelTextController =
                                            TextEditingController();
                                    return AlertDialog(
                                      title: Text("Add Car Details"),
                                      actions: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Car No"),
                                            TextField(
                                              controller: CarNoTextController,
                                            ),
                                            Text("Car Model "),
                                            TextField(
                                              controller:
                                                  CarModelTextController,
                                            ),
                                            ElevatedButton(
                                                onPressed: () => _addCar(
                                                    no: CarNoTextController
                                                        .text,
                                                    model:
                                                        CarModelTextController
                                                            .text),
                                                child: Text("SUBMIT"))
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(
                              Icons.add,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                        children: List.generate(
                            user?['cars']?.length ?? 0,
                            (index) => Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${user!['cars']![index]['no']}"),
                                      Text("${user!['cars']![index]['model']}"),
                                      InkWell(
                                        onTap: () => _deleteCar(index),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                ))))
                  ],
                ),
              ),
            ),
            const Card(
              child: Column(children: [
                Text("Ratings and Reviews"),
              ]),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> _getUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    debugPrint("Profile Page :uid is '$uid'");
    try {
      _snapshot = await db.collection("users").doc(uid).get();
      setState(() {
        user = _snapshot.data();
        debugPrint("Profile${user.toString()}");
      });
    } on FirebaseException catch (e) {
      debugPrint("Profile Page Error: ${e.toString()}");
    }
  }

  Future<void> _deleteCar(int index) async {
    if (user != null) {
      if (uid != null) {
        List<Map<String, dynamic>> updatedCars = List.from(user!['cars']!);
        updatedCars.removeAt(index);
        try {
          //To Update DB
          await db.collection("users").doc(uid).update({
            'cars': updatedCars,
          });
          setState(() {
            //To Update DB
            user!['cars'] = updatedCars;
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        debugPrint("\nUser not found\n");
      }
    } else {
      debugPrint("User data not loaded yet");
    }
  }

  Future<void> _addCar({required String no, required String model}) async {
    if (user != null) {
      List<Map<String, dynamic>> updatedCars = List.from(user?['cars']);
      updatedCars.add({'no': no, 'model': model});
      try {
        await db.collection("users").doc(uid).update({'cars': updatedCars});
        setState(() {
          user!['cars'] = updatedCars;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      debugPrint("User data Loading..");
    }
  }
}
