import 'package:vaayo/src/common_widgets/forms/form_header_widget.dart';
import 'package:vaayo/src/constants/color.dart';
import 'package:vaayo/src/constants/image_strings.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_header_widget.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                FormHeaderWidget(
                    image: tWelcomeScreenImage,
                    title: "Get On Board!",
                    subTitle: "Create your profile to start your Journey"),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Form(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Full Name'),
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('E-Mail'),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Phone No'),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Password'),
                            prefixIcon: Icon(Icons.password_sharp),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {}, child: Text("SIGNUP")),
                        )
                      ],
                    ))),
                Column(
                  children: [
                    const Text("OR"),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image(
                          image: AssetImage("assets/images/google.png"),
                          width: 20.0,
                        ),
                        label: const Text("Sign-In with Google"),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Already have an Account?",
                              style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(text: "LOGIN"),
                        ])))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
