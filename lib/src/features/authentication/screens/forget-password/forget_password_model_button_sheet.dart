import 'package:vaayo/main.dart';
import 'package:vaayo/src/features/authentication/screens/forget-password/forget_password_button_widget.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModelBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Make Selection!",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                  "Select one of the options given below to reset your password.",
                  style: Theme.of(context).textTheme.bodySmall),
              SizedBox(
                height: 30.0,
              ),
              ForgetPassButtonWidget(
                  btnIcon: Icons.mail_outline_rounded,
                  title: "E-Mail",
                  subTitle1: "Reset via E-Mail Verification.",
                  onTap: () {
                    Navigator.pop(context);
                    navKey.currentState?.pushNamed("ForgotPasswordMail");
                  }),
              SizedBox(
                height: 30.0,
              ),
              ForgetPassButtonWidget(
                  btnIcon: Icons.mobile_friendly_rounded,
                  title: "PHone No",
                  subTitle1: "Reset via Phone Verification.",
                  onTap: () {}),
            ],
          )),
    );
  }
}
