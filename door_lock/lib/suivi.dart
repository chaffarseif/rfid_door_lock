import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class suivi extends StatefulWidget {
  const suivi({super.key});
  @override
  State<suivi> createState() => suivid();
}

class suivid extends State<suivi> {
  bool statut = false;
  List users = [];
  bool isLoading = false;

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> getFirebase() async {
    final snapshot = await ref.child('users').get().then((value) => {
          value.children.forEach((element) {
            print(element.value.toString());
            users.add(element.value);
          })
        });
    setState(() {
      isLoading = true;
    });
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
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: isLoading
                    ? ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(children: [
                            const Icon(
                              Icons.door_front_door,
                              size: 35,
                            ),
                            Text(users[index]["name"] +
                                " opened the door " +
                                "at " +
                                users[index]["time"])
                          ]);
                        },
                      )
                    : const Text(
                        "no one opened the door",
                        style: TextStyle(fontSize: 18),
                      )),
          ),
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
