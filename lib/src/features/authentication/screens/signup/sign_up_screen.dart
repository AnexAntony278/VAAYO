import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/forms/form_header_widget.dart';
import 'package:vaayo/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _genderTextController = TextEditingController();
  final TextEditingController _bioTextController = TextEditingController();
  String _errorMessage = "";
  Map<String, dynamic> _userMap = {};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeaderWidget(
                    image: vWelcomeScreenImage,
                    title: "Get On Board!",
                    subTitle: "Create your profile to start your Journey"),
                Container(
                    child: Form(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameTextController,
                      decoration: const InputDecoration(
                        label: Text('Full Name'),
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _emailTextController,
                      decoration: const InputDecoration(
                        label: Text('E-Mail'),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _phoneTextController,
                      decoration: const InputDecoration(
                        label: Text('Phone No'),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordTextController,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                        prefixIcon: Icon(Icons.password_sharp),
                      ),
                    ),
                    TextFormField(
                      controller: _genderTextController,
                      decoration: const InputDecoration(
                        label: Text('Gender'),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _ageTextController,
                      decoration: const InputDecoration(
                        label: Text('Age'),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _bioTextController,
                      decoration: const InputDecoration(
                        label: Text('Bio'),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            //SIGN UP
                            try {
                              //GET DATA FROM FIREAUTH
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text);
                              _userMap['uid'] = userCredential.user?.uid;
                              _userMap['email'] = userCredential.user?.email;
                              _userMap['name'] = _nameTextController.text;
                              _userMap['phone'] = _phoneTextController.text;
                              _userMap['gender'] = _genderTextController.text;
                              _userMap['age'] = _ageTextController.text;
                              _userMap['bio'] = _bioTextController.text;
                              _userMap['cars'] = [];
                              _userMap['tags'] = [];
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .add(_userMap);
                              //STORE UID LOCALLY
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('uid', _userMap['uid']);
                              //SWITCH SCREENS
                              navKey.currentState?.pop();
                              navKey.currentState?.pushNamed("Home");
                              //REMOVE ERROR MESSAGE IF ANY
                              setState(() {
                                _errorMessage = "";
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _errorMessage = e.code;
                              });
                            }
                          },
                          child: const Text("SIGNUP")),
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
                        onPressed: () {
                          navKey.currentState?.pop();
                          navKey.currentState?.pushNamed("LogIn");
                        },
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Already have an Account?",
                              style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(text: " LOGIN"),
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
