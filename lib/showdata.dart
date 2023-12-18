import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Data"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("An error occured"),
            );
          } else if (snapshot.hasData) {
            print(snapshot.data!.docs);
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No data to show"),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data!.docs[index]["title"],
                      ),
                      subtitle: Text(
                        snapshot.data!.docs[index]["description"],
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: Text("An unkonwn error"),
            );
          }
        },
      ),
    );
  }
}
