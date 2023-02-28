import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => addc();
}

class addc extends State<add> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController rfidcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  var uid = const Uuid();
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  bool isLoading = false;
  dynamic user;
  @override
  void initState() {
    super.initState();
    getFirebase();
  }

  Future<void> getFirebase() async {
    final snapshot = await ref.child('add').child('1').get();
    if (snapshot.exists) {
      print(snapshot.value);
      user = snapshot.value;
      rfidcontroller.text = user["RFID"].toString();

      timecontroller.text = user["time"].toString();

      setState(() {
        isLoading = true;
      });
    } else {
      print('No data available.');
    }
  }

  ajouter() {
    if (namecontroller.text.isNotEmpty &&
        rfidcontroller.text.isNotEmpty &&
        timecontroller.text.isNotEmpty) {
      ref.child("users").child(rfidcontroller.text).set({
        "name": namecontroller.text,
        "rfid": rfidcontroller.text,
        "time": timecontroller.text
      });
      ref.child("statut").set(false);
      Navigator.pushNamed(context, "suivi");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("succes"),
                content: const Text("card is add"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ok"),
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("problem"),
                content: const Text("fill all the fields"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ok"),
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text("add card", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, "suivi");
                },
              )),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    labelText: "Name",
                    hintText: "Name",
                    prefixIcon: const Icon(Icons.email),
                  )),
            ),
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                  controller: rfidcontroller,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    labelText: "RFID",
                    hintText: "RFID",
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                  controller: timecontroller,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    labelText: "Time",
                    hintText: "Time",
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: 1)),
                    onPressed: () {
                      Navigator.pushNamed(context, "suivi");
                    },
                    child: const Text(
                      "annuler",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: 1)),
                    onPressed: () {
                      ajouter();
                    },
                    child: const Text("add"),
                  ),
                ),
              ],
            )
          ]),
        )));
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }
}
