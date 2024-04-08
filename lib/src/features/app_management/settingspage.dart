import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaayo/main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SETTINGS"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: [
        TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              navKey.currentState?.pop();
              navKey.currentState?.pushNamed("Welcome");
            },
            child: Text("LOG OUT"))
      ]),
    );
  }
}
