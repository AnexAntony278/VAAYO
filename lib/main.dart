import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/src/constants/image_strings.dart';
import 'package:vaayo/src/features/app_management/home_page.dart';
import 'package:vaayo/src/features/authentication/screens/forget-password/forget_password_mail.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_screen.dart';
import 'package:vaayo/src/features/authentication/screens/login/welcome.dart';
import 'package:vaayo/src/features/authentication/screens/signup/sign_up_screen.dart';
import 'package:vaayo/src/features/manage_rides/screens/book_ride.dart';
import 'package:vaayo/src/features/manage_rides/screens/ride_details.dart';
import 'package:vaayo/src/features/manage_rides/screens/search_ride.dart';
import 'package:vaayo/src/features/manage_trips/screen/create_trips.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:vaayo/src/features/manage_trips/screen/trip_details.dart';
import 'package:vaayo/src/features/profile_management/screens/user_profile.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: 'vaayo_channel_group_key',
        channelKey: 'vaayo',
        channelName: 'vaayo_channel',
        channelDescription: 'Vaayo app notification channel for Ride alert')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'vaayo_channel_group_key',
        channelGroupName: 'vaayo_channel_group')
  ]);

  bool isAllowedNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (isAllowedNotifications) {
    isAllowedNotifications =
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  final prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('uid');
  Widget startScreen =
      (uid == null || uid == "null") ? const WelcomeScreen() : const HomePage();

  runApp(MaterialApp(
    home: startScreen,
    debugShowCheckedModeBanner: false,
    navigatorKey: navKey,
    routes: {
      "Welcome": (BuildContext context) => const WelcomeScreen(),
      "LogIn": (BuildContext context) => const LoginScreen(),
      "SignUp": (BuildContext context) => const SignUpScreen(),
      "Home": (BuildContext context) => const HomePage(),
      "ProfilePage": (BuildContext context) => const UserProfilePage(),
      "RideDetails": (BuildContext context) => const RideDetailsPage(),
      "TripDetails": (BuildContext context) => const TripDetailsPage(),
      "SearchRides": (BuildContext context) => const SearchRidesPage(),
      "CreateTrips": (BuildContext context) => const CreateTripPage(),
      "BookRides": (BuildContext context) => const BookRidePage(),
      "ForgotPasswordMail": (BuildContext context) =>
          const ForgetPasswordMailScreen(),
    },
    theme: ThemeData(
        primaryColor: Colors.lightBlueAccent, cardColor: Colors.blueAccent),
  ));
}
