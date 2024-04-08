import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaayo/main.dart';
import 'package:vaayo/src/features/authentication/screens/forget-password/forget_password_model_button_sheet.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _error_message = "";
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  hintText: "Email")),
          SizedBox(height: 10.0),
          TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  hintText: "Passsword",
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_sharp)))),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _error_message,
                style: TextStyle(color: Colors.red),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      ForgetPasswordScreen.buildShowModelBottomSheet(context);
                    },
                    child: Text("Forgot Password?")),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  try {
                    final UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text);
                    User? user = userCredential.user;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('uid', userCredential.user?.uid ?? '');
                    debugPrint(user.toString());
                    navKey.currentState?.pop();
                    navKey.currentState?.pushNamed("Home");
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      _error_message = e.code;
                    });
                    //TODO- EXCEPTION HANDLING
                  }
                },
                child: const Text(" LOGIN")),
          ),
        ],
      ),
    ));
  }
}
