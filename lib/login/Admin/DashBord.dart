import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/login/Admin/dash2.dart';

class DashBord extends StatefulWidget {
  const DashBord({Key? key, required this.name, required this.userEmail})
      : super(key: key);
  final String name;
  final String userEmail;

  @override
  State<DashBord> createState() => _DashBordState();
}

class _DashBordState extends State<DashBord> {
  final TextStyle whiteText = const TextStyle(color: Colors.white);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer when the page is initialized
    _startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the page is disposed
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    // Create a new timer that triggers every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Call setState to trigger a rebuild of the widget tree
      setState(() {});
    });
  }

  void _cancelTimer() {
    // Cancel the timer if it is running
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "votre Dashboard ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          FutureBuilder<int>(
            future: getUsersCount('Emp'), // Fetch count of employees
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final employeeCount = snapshot.data!;
                return FutureBuilder<int>(
                  future: getUsersCount('Citoyen'), // Fetch count of citizens
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final citizenCount = snapshot.data!;
                      return Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                leading: Container(
                                  alignment: Alignment.bottomCenter,
                                  width: 45.0,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 25,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 40,
                                        width: 8.0,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 30,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                                title: const Text("Aujourd'hui"),
                                subtitle: Text("18 enquetes"),
                              ),
                            ),
                            const VerticalDivider(),
                            Expanded(
                              child: ListTile(
                                leading: Container(
                                  alignment: Alignment.bottomCenter,
                                  width: 45.0,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 25,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 40,
                                        width: 8.0,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 30,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                                title: const Text("Canceled"),
                                subtitle: Text("7"),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: FutureBuilder<int>(
                    future: getUsersCount('Citoyen'), // Fetch count of citizens
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final citizenCount = snapshot.data!;
                        return _buildTile(
                          color: Colors.pink,
                          icon: Icons.portrait,
                          title: "Nombre des Citoyens",
                          data: "$citizenCount",
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: FutureBuilder<int>(
                    future: getUsersCount('Emp'), // Fetch count of employees
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final employeeCount = snapshot.data!;
                        return _buildTile(
                          color: Colors.green,
                          icon: Icons.portrait,
                          title: "Nombre des Employés",
                          data: "$employeeCount",
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FutureBuilder<String>(
                    future:
                        getFilledSurveysCount(), // Fetch total count of filled surveys
                    // Fetch total count of filled surveys
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final filledSurveysCount = snapshot.data!;
                        return _buildTile(
                          color: Colors.blue,
                          icon: Icons.favorite,
                          title: "Enquête remplie",
                          data: filledSurveysCount,
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildTile(
                    color: Colors.pink,
                    icon: Icons.portrait,
                    title: "Personne connectée",
                    data: "857",
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildTile(
                    color: Colors.blue,
                    icon: Icons.favorite,
                    title: "Citoyen par région",
                    data: "7 regions",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegionCitoyen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 32.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: Color.fromARGB(255, 94, 6, 247),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          ListTile(
            title: Text(
              "Dashboard",
              style: whiteText.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            trailing: CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage('assets/avatar1.jpg'),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Dr " + widget.name,
              style: whiteText.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
        ],
      ),
    );
  }

  InkWell _buildTile({
    Color? color,
    IconData? icon,
    required String title,
    required String data,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap, // Assign the onTap function to the InkWell
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              title,
              style: whiteText.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              data,
              style: whiteText.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> getUsersCount(String role) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Role', isEqualTo: role)
        .get();
    return querySnapshot.size;
  }

  Future<String> getFilledSurveysCount() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Citoyen').get();

    int totalCount = 0;

    for (final docSnapshot in querySnapshot.docs) {
      final subCollectionSnapshot =
          await docSnapshot.reference.collection('data').doc('Depense').get();

      if (subCollectionSnapshot.exists &&
          subCollectionSnapshot.data() != null &&
          subCollectionSnapshot.data()!.isNotEmpty) {
        totalCount++;
      }
    }

    return totalCount.toString();
  }
}
