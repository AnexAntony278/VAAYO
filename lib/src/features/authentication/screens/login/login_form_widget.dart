import 'package:vaayo/src/features/authentication/screens/forget-password/forget_password_button_widget.dart';
import 'package:vaayo/src/features/authentication/screens/forget-password/forget_password_model_button_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  hintText: "Email")),
          SizedBox(height: 10.0),
          TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password_sharp),
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  hintText: "Passsword",
                  suffixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.remove_red_eye_sharp)))),
          const SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  ForgetPasswordScreen.buildShowModelBottomSheet(context);
                },
                child: Text("Forgot Password?")),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, child: Text("LOGIN")),
          ),
        ],
      ),
    ));
  }
}
