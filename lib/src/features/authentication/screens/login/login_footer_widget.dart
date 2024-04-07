import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("OR"),
              SizedBox(height: 10.0,),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Image(image: AssetImage("assets/images/google.png"),width: 30.0),
                  onPressed: (){},
                   label: Text("Sign-in with Google")
                   ),
              ),
              const SizedBox(height: 10.0,),
              TextButton(
                onPressed: (){},
                 child: Text.rich(
                  TextSpan(
                  text: "Don't have an Account?",
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(
                      text: "Signup",
                      style: TextStyle(color:Colors.blue)
                      ),
                    
                  ]
                  )
                  )
                 )
            ],
          );
  }
}

