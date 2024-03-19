import 'package:flutter/material.dart';
import 'package:vaayo/pages/pages.dart';
import 'package:vaayo/pages/profile.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _navBarIndex = 0;
  Widget _selectedPage = const RidePage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navKey,
        routes: {
          "ProfilePage": (BuildContext context) => ProfilePage(userId: 3),
          "RideDetails": (BuildContext context) => const RideDetailsPage(
                rideId: 3,
              )
        },
        theme: ThemeData(
            primaryColor: Colors.lightBlueAccent,
            fontFamily: "BebasNeue",
            cardColor: Colors.blueAccent),
        home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: const Text("VAAYO"),
                toolbarHeight: 80,
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColorDark,
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          navKey.currentState?.pushNamed("ProfilePage");
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.supervised_user_circle_sharp),
                        ),
                      ))
                ],
              ),
              body: _selectedPage,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _navBarIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.location_city), label: "MyRides"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.emoji_transportation), label: "MyTrips"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings")
                ],
                elevation: 50,
                onTap: (value) {
                  setState(() {
                    _navBarIndex = value;
                    switch (value) {
                      case 0:
                        _selectedPage = const RidePage();
                      case 1:
                        _selectedPage = const Text("Trip");
                      case 2:
                        _selectedPage = const Text("SETTINGS");
                      default:
                        _selectedPage = const Text("RIDES");
                    }
                  });
                },
              )),
        ));
  }
}
