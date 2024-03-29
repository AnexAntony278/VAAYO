import 'package:flutter/material.dart';
import 'package:vaayo/src/features/app_navigation/start_page.dart';
import 'package:vaayo/src/features/manage_rides/screens/ride_details.dart';
import 'package:vaayo/src/features/manage_rides/screens/search_ride.dart';
import 'package:vaayo/src/features/manage_trips/screen/create_trips.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vaayo/src/features/profile_management/screens/user_profile.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: const StartPage(),
    debugShowCheckedModeBanner: false,
    navigatorKey: navKey,
    routes: {
      "ProfilePage": (BuildContext context) => const UserProfilePage(userId: 3),
      "RideDetails": (BuildContext context) => const RideDetailsPage(rideId: 3),
      "SearchRides": (BuildContext context) => const SearchRidesPage(),
      "CreateTrips": (BuildContext context) => const CreateTripPage(),
    },
    theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
        fontFamily: "BebasNeue",
        cardColor: Colors.blueAccent),
  ));
}
