import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/uihelper.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();

  forgetPassword(String email) async {
    if (email == "") {
      return UiHelper.CustomAlertBox(
          context, "enter an email to reset passwod");
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
        const SizedBox(
          height: 20,
        ),
        UiHelper.CustomButton(
          () {
            forgetPassword(emailController.text.toString());
          },
          "Reset Password",
        )
      ]),
    );
  }
}
