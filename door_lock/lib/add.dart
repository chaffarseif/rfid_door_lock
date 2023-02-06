import 'package:flutter/material.dart';
import 'package:door_lock/suivi.dart';

class add extends StatefulWidget {
  @override
  State<add> createState() => addc();
}

class addc extends State<add> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController rfidcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  ajouter() {
    if (namecontroller == namecontroller.text &&
        rfidcontroller == rfidcontroller.text &&
        timecontroller == timecontroller.text) {
      Navigator.pushNamed(context, "suivi");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("succes"),
                content: Text("card is add"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("ok"),
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("problem"),
                content: Text("fill all the fields"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("ok"),
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
          title: Text("add card", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, "suivi");
                },
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
        ),
        body: SafeArea(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  labelText: "Name",
                  hintText: "Name",
                  prefixIcon: Icon(Icons.email),
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                controller: rfidcontroller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
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
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  labelText: "Time",
                  hintText: "Time",
                ),
              )),
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: getColor(Colors.black, Colors.white),
                    backgroundColor:
                        getColor(Colors.white, Colors.indigoAccent)),
                onPressed: () {
                  Navigator.pushNamed(context, "suivi");
                },
                child: Text("annuler"),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: getColor(Colors.black, Colors.white),
                    backgroundColor:
                        getColor(Colors.white, Colors.indigoAccent)),
                onPressed: () {
                  ajouter();
                },
                child: Text("add"),
              ),
            ],
          )
        ])));
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }
}
