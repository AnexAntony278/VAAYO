import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/constants/theme.dart';

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
        leading: null,
        title: const Text(
          "SETTINGS",
          style: VaayoTheme.mediumBold,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: [
        TextButton(onPressed: _logOut, child: const Text("LOG OUT"))
      ]),
    );
  }

  _logOut() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', "null");
    debugPrint("\nSettings Page: uid :${prefs.get('uid')}");
    navKey.currentState?.pop();
    navKey.currentState?.pushNamed("Welcome");
  }
}
