import 'package:flutter/material.dart';
import 'package:vaayo/pages/widgets.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage({required this.userId, super.key});
  final int userId;
  final Map user = {
    "name": "ANEX ANTONY",
    "age": 10,
    "gender": 'M',
    "phone": "7034456811",
    "email": "anexantony278@gmail.com",
    "bio": "I am a SOftware Enginerring student who loves Gaming",
    "tags": ["pets", "music", "gaming"],
    "cars": [
      "KL2021",
    ]
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MY PROFILE"),
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
                          "Hi There,\n${user["name"]},\n",
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
                          data: user["age"].toString(),
                          noOfBox: 2,
                        ),
                        TextDataBox(
                          text: "gender",
                          data: user["gender"],
                          noOfBox: 2,
                        ),
                        TextDataBox(
                            text: "email", data: user["email"], noOfBox: 1),
                        TextDataBox(
                            text: "Phone.no", data: user['phone'], noOfBox: 1),
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
                                                user['tags'].length,
                                                (index) => Chip(
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                    label: Text(
                                                      '# ${user['tags'][index]}',
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    )))),
                                        Text(user['bio']),
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
                            user['cars'].length,
                            (index) => Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text("${user['cars'][index]}  -"),
                                    ],
                                  ),
                                ))))
                  ],
                ),
              ),
            ),
            Card(
              child: Column(children: [
                Text("Ratings and Rewiews"),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
