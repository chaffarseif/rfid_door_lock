import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class suivi extends StatefulWidget {
  const suivi({super.key});
  @override
  State<suivi> createState() => suivid();
}

class suivid extends State<suivi> {
  bool statut = false;
  dynamic user;
  bool isLoading = false;

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> getFirebase() async {
    final snapshot = await ref.child('users').get();
    if (snapshot.exists) {
      print(snapshot.value);
      user = snapshot.value;
      setState(() {
        isLoading = true;
      });
    } else {
      print('No data available.');
    }
  }

  @override
  void initState() {
    super.initState();
    getFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Door lock", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {},
            icon: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, "login");
                statut = true;
              },
            )),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        )),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  const Icon(
                    Icons.door_sliding_rounded,
                    size: 80,
                  ),
                  isLoading
                      ? Text(
                          "${user["name"]} opened the door",
                          style: const TextStyle(fontSize: 18),
                        )
                      : const Text(
                          "no one opened the door",
                          style: TextStyle(fontSize: 18),
                        )
                ],
              ),
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "add");
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
