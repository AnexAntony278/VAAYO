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
                const FormHeaderWidget(
                    image: vWelcomeScreenImage,
                    title: "Get On Board!",
                    subTitle: "Create your profile to start your Journey"),
                Form(
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
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _emailTextController,
                      decoration: const InputDecoration(
                        label: Text('E-Mail'),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _phoneTextController,
                      decoration: const InputDecoration(
                        label: Text('Phone No'),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(
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
                        labelText: 'Gender',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your gender';
                        }
                        String lowercaseValue = value.toLowerCase();
                        if (lowercaseValue != 'M' && lowercaseValue != 'F') {
                          return 'Gender must be either "M" or "F"';
                        }
                        return null;
                      },
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
                          onPressed: _signUp, child: const Text("SIGNUP")),
                    )
                  ],
                )),
                Column(
                  children: [
                    const Text("OR"),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Image(
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
                          const TextSpan(text: " LOGIN"),
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

  void _signUp() async {
    //SIGN UP
    try {
      Map<String, dynamic> userMap = {};
      //GET DATA FROM FIREAUTH
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text);
      userMap['email'] = userCredential.user?.email;
      userMap['name'] = _nameTextController.text;
      userMap['phone'] = _phoneTextController.text;
      userMap['gender'] = _genderTextController.text;
      userMap['age'] = _ageTextController.text;
      userMap['bio'] = _bioTextController.text;
      userMap['cars'] = [];
      userMap['tags'] = [];
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user?.uid)
          .set(userMap);
      //STORE UID LOCALLY
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', userCredential.user?.uid ?? "null");
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
  }
}
