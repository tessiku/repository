import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ins_app/Pages1/LoginPage.dart';
import 'package:ins_app/Pages1/StatsPage.dart';
import 'package:ins_app/Signup.dart';
import 'package:ins_app/login/HomePageLogin.dart';

import '../Pages1/AccountPage.dart';
import '../Pages1/HomePage.dart';
import '../Pages1/SettingsPage.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Bottom Navigation Bar',
      home: GreedingPage(),
    ),
  );
}

class GreedingPage extends StatefulWidget {
  @override
  GreedingPageState createState() => GreedingPageState();
}

class GreedingPageState extends State<GreedingPage> {
  var currentIndex = 0;
  final List<Widget> listOfPages = [
    HomePage(title: ''),
    StatsPage(),
    SettingsPage(),
    LoginPage()
  ];
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: currentIndex,
          children: listOfPages,
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(displayWidth * .05),
          height: displayWidth * .155,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  currentIndex = index;
                  HapticFeedback.lightImpact();
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex
                        ? displayWidth * .32
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == currentIndex ? displayWidth * .12 : 0,
                      width: index == currentIndex ? displayWidth * .32 : 0,
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? Color.fromARGB(255, 161, 0, 254).withOpacity(.2)
                            : Color.fromARGB(0, 239, 233, 233),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex
                        ? displayWidth * .31
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex
                                  ? displayWidth * .13
                                  : 0,
                            ),
                            AnimatedOpacity(
                              opacity: index == currentIndex ? 1 : 0,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Text(
                                index == currentIndex
                                    ? '${listOfStrings[index]}'
                                    : '',
                                style: TextStyle(
                                  color: Color.fromARGB(166, 131, 75, 244),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex
                                  ? displayWidth * .03
                                  : 20,
                            ),
                            Icon(
                              listOfIcons[index],
                              size: displayWidth * .076,
                              color: index == currentIndex
                                  ? Colors.blueAccent
                                  : Colors.black26,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Favorite',
    'Settings',
    'Account',
  ];
}
