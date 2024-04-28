import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/features/authentication/screens/forget-password/forget_password_model_button_sheet.dart';

final _formKey = GlobalKey<FormState>();

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String errorMessage = "";
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailTextController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  hintText: "Email"),
              validator: validateEmail,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key),
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  hintText: "Passsword",
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove_red_eye_sharp))),
              validator: validatePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        ForgetPasswordScreen.buildShowModelBottomSheet(context);
                      },
                      child: const Text("Forgot Password?")),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      userLogin();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter Valid Credentials'),
                        ),
                      );
                    }
                  },
                  child: const Text(" LOGIN")),
            ),
          ],
        ),
      ),
    ));
  }

  void userLogin() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', userCredential.user?.uid ?? 'null');
      debugPrint("\nLoginPage: uid:${prefs.getString('uid')}");
      navKey.currentState?.pop();
      navKey.currentState?.pushNamed("Home");
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.code;
      });
      //TODO- EXCEPTION HANDLING
    }
  }

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._-]{6,}@(gmail\.com)$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return "Please enter a valid email";
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
    return null; // Return null if password is valid
  }
}
