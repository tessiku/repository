import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ins_app/Pages1/LoginPage.dart';
import 'package:ins_app/Pages1/StatsPage.dart';
import 'package:ins_app/Signup.dart';
import 'package:ins_app/login/HomePageLogin.dart';

import '../Pages1/HomePage.dart';

class GreedingPage extends StatefulWidget {
  @override
  GreedingPageState createState() => GreedingPageState();
}

class GreedingPageState extends State<GreedingPage> {
  var currentIndex = 0;
  final List<Widget> listOfPages = [
    HomePage(title: ''),
    StatsPage(),
    LoginPage(),
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
          margin: EdgeInsets.all(displayWidth * .02),
          height: displayWidth * .155,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 134, 36, 225).withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: 3, // Number of pages
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
            itemBuilder: (context, index) => InkWell(
              // InkWell is a widget that makes the page indicator clickable
              onTap: () {
                // and it's used to change the page fi el navigation bar
                setState(() {
                  currentIndex = index;
                  HapticFeedback.lightImpact();
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                width: displayWidth * 0.32, // Adjust the width as needed
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
                        //shadow of the page indicator display
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == currentIndex ? displayWidth * .12 : 0,
                        width: index == currentIndex ? displayWidth * .28 : 0,
                        decoration: BoxDecoration(
                          color: index == currentIndex
                              ? Color.fromARGB(255, 67, 67, 67).withOpacity(.2)
                              : Color.fromARGB(0, 31, 31, 31),
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
                                    color: Color.fromARGB(245, 73, 23,
                                        224), // Name of the page indicator color
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
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
                                // Icon of the page indicator
                                listOfIcons[index],
                                size: displayWidth * .076,
                                color: index == currentIndex
                                    ? Color.fromARGB(255, 45, 38,
                                        233) // Color of the icon of the page
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
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.stacked_bar_chart_sharp,
    Icons.settings_rounded,
  ];

  List<String> listOfStrings = [
    'accueil',
    'stat',
    'login',
  ];
}
