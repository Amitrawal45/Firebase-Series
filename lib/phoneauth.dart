import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/otpscreen.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

TextEditingController phoneController = TextEditingController();

class _PhoneAuthState extends State<PhoneAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Authentation"),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "Enter Phone Number",
                suffixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24))),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.verifyPhoneNumber(
                  verificationCompleted: (PhoneAuthCredential crediential) {},
                  verificationFailed: (FirebaseAuthException ex) {},
                  codeSent: (String verficationId, int? resendtoken) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpScreen(
                                  verificationId: verficationId,
                                )));
                  },
                  codeAutoRetrievalTimeout: (String verificationid) {},
                  phoneNumber: phoneController.text.toString());
            },
            child: const Text("Verify Phone Number"))
      ]),
    );
  }
}
