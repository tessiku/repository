import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ins_app/AuthPage.dart';
import 'package:ins_app/add_data.dart';
import 'package:ins_app/data_view.dart';
import 'package:ins_app/greeding/GreedingPage.dart';
import 'homepage.dart';
import 'create_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Initialization(null);
  runApp(MyApp());
}

Future Initialization(BuildContext? context) async {
  await Firebase.initializeApp();
  await Future.delayed(Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GreedingPage(),
    );
  }
}
