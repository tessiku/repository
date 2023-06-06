import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ins_app/Pages1/SplashScreen.dart';
import 'package:ins_app/Signup.dart';
import 'package:ins_app/greeding/GreedingPage.dart';
import 'package:ins_app/login/HomePageLogin.dart';
import 'package:ins_app/login/Work/AddPerson.dart';
import 'package:ins_app/services/AddGeneralInfo.dart';
import 'package:ins_app/services/Cin_Collector.dart';
import 'package:ins_app/services/Data_View.dart';
import 'package:ins_app/services/Display_Data_Docs.dart';
import 'package:ins_app/services/GetData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';


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
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      //GreedingPage(),
    );
  }
}
