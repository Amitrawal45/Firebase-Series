import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_series/uihelper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CloudStorage extends StatefulWidget {
  const CloudStorage({super.key});

  @override
  State<CloudStorage> createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? pickedImage;

  signUp(String email, String password) async {
    if (email == "" && password == "" && pickedImage == null) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Enter required filed"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Okay"))
              ],
            );
          });
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          uploadData();
        });
      } on FirebaseAuthException catch (ex) {
        print(ex.code.toString());
      }
    }
  }

  uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("Profile pics")
        .child(emailController.text.toString())
        .putFile(pickedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("User")
        .doc(emailController.text.toString())
        .set({"Email": emailController.text.toString(), "Image": url}).then(
            (value) {
      print("User Uploaded");
    });
  }

  showAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Pick image from"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                ),
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image),
                  title: const Text("Gellery"),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup Page"),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        InkWell(
          onTap: () {
            showAlertBox();
          },
          child: pickedImage != null
              ? CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(pickedImage!),
                )
              : const CircleAvatar(
                  radius: 80,
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
        ),
        UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
        UiHelper.CustomTextField(
            passwordController, "Password", Icons.password, true),
        const SizedBox(
          height: 20,
        ),
        UiHelper.CustomButton(() {
          signUp(emailController.text.toString(),
              passwordController.text.toString());
        }, "Sign Up")
      ]),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) {
        return;
      } else {
        final tempImage = File(photo.path);
        setState(() {
          pickedImage = tempImage;
        });
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
