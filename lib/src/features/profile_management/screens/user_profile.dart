import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vaayo/src/common_widgets/widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({required this.userId, super.key});
  final int userId;
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? user;
  Future<void> getUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: "ANEX ANTONY")
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        user = snapshot.docs.first.data();
      });
    } else {
      debugPrint('User not found!');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
          padding: EdgeInsets.all(20),
          child: ListView(children: [
            Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(10.0),
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
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MY RIDES",
                      style: TextStyle(fontSize: 20),
                    ),
                    Column(
                        children: List.generate(
                            user?['cars']?.length ?? 0,
                            (index) => Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text("${user!['cars']![index]}  -"),
                                    ],
                                  ),
                                ))))
                  ],
                ),
              ),
            ),
            Card(
              child: Column(children: [
                Text("Ratings and Reviews"),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
