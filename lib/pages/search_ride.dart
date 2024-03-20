import 'package:flutter/material.dart';

class SearchRidesPage extends StatelessWidget {
  const SearchRidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SEARCH RIDES"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [Text("From"), Text("To"), Text("aa")],
          ),
        ));
  }
}
