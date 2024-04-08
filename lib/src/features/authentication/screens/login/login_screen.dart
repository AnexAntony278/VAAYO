import 'package:vaayo/main.dart';
import 'package:vaayo/src/constants/image_strings.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(vWelcomeScreenImage),
                              height: size.height * 0.2,
                            ),
                            Text("Welcome Back"),
                            Text("Get there with Vaayo"),
                          ],
                        ),
                        const LoginForm(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("OR"),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                  icon: Image(
                                      image: AssetImage(
                                          "assets/images/google.png"),
                                      width: 30.0),
                                  onPressed: () {},
                                  label: Text("Sign-in with Google")),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextButton(
                                onPressed: () =>
                                    navKey.currentState?.pushNamed("SignUp"),
                                child: Text.rich(TextSpan(
                                    text: "Don't have an Account?",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    children: [
                                      TextSpan(
                                          text: "Signup",
                                          style: TextStyle(color: Colors.blue)),
                                    ])))
                          ],
                        )
                      ])))),
    );
  }
}
