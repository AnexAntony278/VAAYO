import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/common_widgets/forms/form_header_widget.dart';
import 'package:vaayo/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _bioTextController = TextEditingController();
  String _errorMessage = "";

  String selectedGender = '';
  List listItem = ["M", "F"];

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }

    RegExp regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)?$');
    if (!regex.hasMatch(name)) {
      return 'Name must contain only alphabetic characters (a-z)';
    }
    return null;
  }

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    }

    RegExp regex = RegExp(r'^[0-9]+$');

    if (!regex.hasMatch(phoneNumber)) {
      return 'Phone number must contain only digits (0-9)';
    }

    if (phoneNumber.length < 10) {
      return 'Phone number must contain 10 digits';
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 8 characters long';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    if (!value.contains(RegExp(r'[0-9]+$'))) {
      return 'Please enter a valid age';
    }
    /*if (!value.contains(RegExp(r'[a-z]'))) {
        return 'Please enter a valid age';
      }*/
    if (int.parse(value) < 18) {
      return 'Please enter a valid age';
    }
    return null;
  }

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
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameTextController,
                          decoration: const InputDecoration(
                            label: Text('Full Name'),
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: validateName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          validator: validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          validator: validatePhoneNumber,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          validator: validatePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        DropdownMenu(
                          label: const Text('Gender'),
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: 'M', label: 'Male'),
                            DropdownMenuEntry(value: 'F', label: 'Female'),
                            //DropdownMenuEntry(value: 'O', label: 'Others'),
                          ],
                          onSelected: (gender) {
                            if (gender != null) {
                              setState(() {
                                selectedGender = gender;
                              });
                            }
                          },
                        ),
                        TextFormField(
                          controller: _ageTextController,
                          decoration: const InputDecoration(
                            label: Text('Age'),
                          ),
                          validator: validateAge,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return (value == null) ? 'Enter Bio' : null;
                          },
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
                            onPressed: () {
                              if (selectedGender != "") {
                                if (_formKey.currentState!.validate()) {
                                  _signUp();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter valid information'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter gender'),
                                  ),
                                );
                              }
                            },
                            child: const Text("SIGNUP"),
                          ),
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
      userMap['gender'] = selectedGender;
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
