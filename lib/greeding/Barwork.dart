import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

import '../login/Work/Add.dart';
import '../login/Work/CheckPage.dart';
import '../login/Work/DeletePage.dart';
import '../login/Work/EventListPage.dart';

class MyCustomWidget extends StatelessWidget {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          // Cannot be Alignment.center
          alignment: Alignment.bottomRight,
          ringColor: Color.fromARGB(255, 0, 0, 0).withAlpha(25),
          ringDiameter: 500.0,
          ringWidth: 150.0,
          fabSize: 64.0,
          fabElevation: 8.0,
          fabIconBorder: CircleBorder(),

          fabColor: Color.fromARGB(255, 0, 0, 0),
          fabOpenIcon: Icon(Icons.menu, color: primaryColor),
          fabCloseIcon: Icon(Icons.close, color: primaryColor),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) {
            _showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
          },
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                _navigateToPage(context, "Page 1");
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_one, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            RawMaterialButton(
              onPressed: () {
                _navigateToPage(context, "Page 2");
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_two, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            RawMaterialButton(
              onPressed: () {
                _navigateToPage(context, "Page 3");
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_3, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            RawMaterialButton(
              onPressed: () {
                _navigateToPage(context, "Page 4");
                fabKey.currentState?.close();
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.looks_4, color: Color.fromARGB(255, 0, 0, 0)),
            )
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // Updated: Changed Scaffold.of(context) to ScaffoldMessenger.of(context)
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }

  void _navigateToPage(BuildContext context, String pageTitle) {
    Widget page;

    switch (pageTitle) {
      case "Page 1":
        page = AddPerson('');
        break;
      case "Page 2":
        page = CheckPage();
        break;
      case "Page 3":
        page = DeletePage();
        break;
      case "Page 4":
        page = EventListPage();
        break;
      default:
        page = Container(); // Provide a fallback page or handle error case
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
