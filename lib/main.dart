import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaayo/src/features/app_management/start_page.dart';
import 'package:vaayo/src/features/authentication/screens/forget-password/forget_password_mail.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_screen.dart';
import 'package:vaayo/src/features/authentication/screens/login/welcome.dart';
import 'package:vaayo/src/features/authentication/screens/signup/sign_up_screen.dart';
import 'package:vaayo/src/features/manage_rides/screens/ride_details.dart';
import 'package:vaayo/src/features/manage_rides/screens/search_ride.dart';
import 'package:vaayo/src/features/manage_trips/screen/create_trips.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vaayo/src/features/profile_management/screens/user_profile.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Widget startScreen = WelcomeScreen();
  runApp(MaterialApp(
    home: startScreen,
    debugShowCheckedModeBanner: false,
    navigatorKey: navKey,
    routes: {
      "Welcome": (BuildContext context) => const WelcomeScreen(),
      "LogIn": (BuildContext context) => const LoginScreen(),
      "SignUp": (BuildContext context) => const SignUpScreen(),
      "Home": (BuildContext context) => const HomePage(),
      "ProfilePage": (BuildContext context) => const UserProfilePage(userId: 3),
      "RideDetails": (BuildContext context) => const RideDetailsPage(rideId: 3),
      "SearchRides": (BuildContext context) => const SearchRidesPage(),
      "CreateTrips": (BuildContext context) => const CreateTripPage(),
      "ForgotPasswordMail": (BuildContext context) =>
          const ForgetPasswordMailScreen(),
    },
    theme: ThemeData(
        primaryColor: Colors.lightBlueAccent, cardColor: Colors.blueAccent),
  ));
}
