import 'package:door_lock/login.dart';
import 'package:door_lock/suivi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:door_lock/add.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          elevation: 8,
          shape: const CircleBorder(),
          minimumSize: const Size.square(60),
        ))),
    routes: {
      "login": (context) => const login(),
      "suivi": (context) => const suivi(),
      "add": (context) => const add()
    },
    home: const suivi(),
  ));
}
