import 'package:flutter/material.dart';
import 'package:vaayo/src/features/app_management/notification_manager.dart';

class FontTest extends StatelessWidget {
  const FontTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text("TITLE LARGE",
                style: Theme.of(context).textTheme.headlineLarge),
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
            ElevatedButton(
                onPressed: () {
                  NotificationService().showNotification(
                      id: 1, title: 'title', body: 'hiiiiiiiiiiiibodyyy');
                },
                child: const Text('NOTIFY'))
          ],
        ),
      ),
    );
  }
}
