//import 'package:vaayo/src/constants/image_strings.dart';
import 'package:vaayo/src/common_widgets/forms/form_header_widget.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:vaayo/src/features/authentication/screens/login/login_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                        const FormHeaderWidget(
                          image: "assets/images/vaayo.png",
                          title: "Welcome Back",
                          subTitle: "Get there with Vaayo",
                        ),
                        LoginHeaderWidget(size: size),
                        const LoginForm(),
                        const LoginFooterWidget()
                      ])))),
    );
  }
}
