import 'package:flutter/material.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/constants/theme.dart';
import 'package:vaayo/src/features/app_management/settings_page.dart';
import 'package:vaayo/src/features/manage_rides/screens/ride_list.dart';
import 'package:vaayo/src/features/manage_trips/screen/trip_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navBarIndex = 0;
  Widget _selectedPage = const RidesPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "VAAYO",
                style: VaayoTheme.largeBold,
              ),
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
                    icon: Icon(Icons.emoji_transportation), label: "My Rides"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.time_to_leave), label: "My Trips"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Settings")
              ],
              elevation: 50,
              onTap: (value) async {
                setState(() {
                  _navBarIndex = value;
                  switch (value) {
                    case 0:
                      _selectedPage = const RidesPage();
                      break;
                    case 1:
                      _selectedPage = const TripsPage();
                      break;
                    case 2:
                      _selectedPage = SettingsPage();
                      break;
                    default:
                      _selectedPage = const RidesPage();
                      break;
                  }
                });
              },
            )),
      ),
    );
  }
}
