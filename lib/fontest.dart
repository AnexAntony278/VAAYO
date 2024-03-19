import 'package:flutter/material.dart';

class FontTest extends StatelessWidget {
  const FontTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text(
              "TITLE LARGE",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "DISPLAY Large",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              "DISPLAY Medium",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              "BODY LARGE",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "BODY MEDIUM",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
