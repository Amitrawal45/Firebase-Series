import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptonController = TextEditingController();

  addData(String title, String description) async {
    if (title == "" && description == "") {
      print("Enter required fiels");
    } else {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(title)
          .set({"Title": title, "Description": description}).then((value) {
        print("Data Inserted");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Data"),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: "Enter Title",
                suffix: const Icon(Icons.title),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25))),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: descriptonController,
            decoration: InputDecoration(
                hintText: "EnterDescription",
                suffix: const Icon(Icons.description),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25))),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () {
              addData(titleController.text.toString(),
                  descriptonController.text.toString());
            },
            child: const Text("Save Data"))
      ]),
    );
  }
}
