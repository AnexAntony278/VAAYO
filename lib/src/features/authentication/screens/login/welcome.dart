//import 'package:vaayo/src/constants/color.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/constants/color.dart';
import 'package:vaayo/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

//import 'package:vaayo/src/constants/sizes.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: isDarkMode ? vSecondaryColor : vPrimaryColor,
        body: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                  image: AssetImage(tWelcomeScreenImage), height: height * 0.6),
              Column(
                children: [
                  Text(
                    'Vaayo',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Get there with Vaayo',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () =>
                              navKey.currentState?.pushNamed("LogIn"),
                          child: Text("Login".toUpperCase()))),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () =>
                              navKey.currentState?.pushNamed("SignUp"),
                          child: Text('Signup'.toUpperCase())))
                ],
              )
            ],
          ),
        ));
  }
}
