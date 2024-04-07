import 'package:vaayo/src/common_widgets/forms/form_header_widget.dart';
import 'package:flutter/material.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 30.0 * 4),
            const FormHeaderWidget(
              image: "assets/images/logo.png",
              title: "Forget Password",
              subTitle:
                  "Select one of the options given below to reset your password",
              crossAxisAlignment: CrossAxisAlignment.center,
              heightBetween: 30.0,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: Text("Email"),
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(onPressed: () {}, child: Text("Next")),
              ],
            ))
          ],
        ),
      ),
    ));
  }
}
