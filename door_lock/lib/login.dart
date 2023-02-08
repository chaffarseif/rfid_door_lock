import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => logint();
}

class logint extends State<login> {
  bool obscureText = true;
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  login() {
    String user = "app";
    String pass = "app";
    if (user == usercontroller.text && pass == passcontroller.text) {
      Navigator.pushNamed(context, "suivi");
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Connection problem"),
          content: const Text("Check your password or your email"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("ok"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(Icons.lock, size: 100),
              const SizedBox(
                height: 50,
              ),
              Text(
                'welcome in Door Lock App',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                    controller: usercontroller,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      labelText: "user",
                      hintText: "user",
                      prefixIcon: const Icon(Icons.email),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                  controller: passcontroller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      labelText: "password",
                      hintText: "password",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: Icon(obscureText
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: getColor(Colors.black, Colors.white),
                      backgroundColor:
                          getColor(Colors.white, Colors.indigoAccent)),
                  onPressed: () {
                    login();
                  },
                  child: Container(
                    child: const Icon(
                      Icons.login_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ))
            ]),
          ),
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
