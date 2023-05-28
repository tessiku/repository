import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddGeneralInfo.dart';
import 'Enquette.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Display_Data_Docs extends StatefulWidget {
  final String cin;
  final String documentID;

  Display_Data_Docs({required this.cin, required this.documentID});

  @override
  _Display_Data_DocsState createState() => _Display_Data_DocsState();
}

class _Display_Data_DocsState extends State<Display_Data_Docs> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _futureDocument;

  @override
  void initState() {
    super.initState();
    _futureDocument = FirebaseFirestore.instance
        .collection('Citoyen')
        .doc(widget.cin)
        .collection('data')
        .doc(widget.documentID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
          width: 150,
          child: Transform.scale(
            scale: 1,
            child: Text(
              'Display Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _futureDocument,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data found.'));
            }

            final data = snapshot.data!.data()!;

            return AnimationLimiter(
              child: Container(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: data.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == data.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: MaterialButton(
                                height: 50,
                                minWidth: 100,
                                color: Color.fromARGB(194, 168, 168, 168),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                onPressed: () {
                                  if (snapshot.data!.id == 'Depense') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Enquette(
                                          cin: widget.cin,
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.data!.id ==
                                      'General info') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AddGeneralInfo(
                                          cin: widget.cin,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final entry = data.entries.elementAt(index);
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: Duration(milliseconds: 100),
                        child: SlideAnimation(
                          duration: Duration(milliseconds: 500),
                          verticalOffset: 50.0,
                          child: InkWell(
                            onTap: () {
                              // Perform actions on tap if needed
                            },
                            child: Card(
                              color: Color.fromARGB(255, 192, 192, 192),
                              shadowColor: Color.fromARGB(255, 210, 210, 210),
                              elevation: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          _getIconForEntry(entry.key),
                                          // Get the icon based on entry.key
                                          SizedBox(width: 8.0),
                                          Text(
                                            entry.key.replaceFirst(entry.key[0],
                                                entry.key[0].toUpperCase()),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(width: 10.0),
                                          Expanded(
                                            child: Text(
                                              entry.value.toString(),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                            ),
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
                  },
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Icon _getIconForEntry(String key) {
    switch (key) {
      case 'nutrition':
        return Icon(Icons.food_bank_outlined);
      case 'vetements':
        return Icon(Icons.shopping_bag_outlined);
      case 'sante':
        return Icon(Icons.medical_services_outlined);
      case 'profession':
        return Icon(Icons.work_outline_outlined);
      case 'nombre_p':
        return Icon(Icons.people_alt_outlined);
      case 'decile':
        return Icon(Icons.money_off_outlined);
      case 'zone':
        return Icon(Icons.location_on_outlined);
      case 'salaire':
        return Icon(Icons.money_outlined);
      case 'type':
        return Icon(Icons.category_outlined);
      case 'divertissement':
        return Icon(Icons.sports_esports_outlined);
      case 'transport':
        return Icon(Icons.commute_outlined);
      case 'services publics':
        return Icon(Icons.home_outlined);
      case 'education':
        return Icon(Icons.school_outlined);
      case 'logement':
        return Icon(Icons.house_outlined);
      case 'voyages':
        return Icon(Icons.flight_outlined);
      case 'telecommunications':
        return Icon(Icons.phone_outlined);
      case 'services professionnels':
        return Icon(Icons.business_outlined);
      case 'assurances':
        return Icon(Icons.security_outlined);
      case 'electronique':
        return Icon(Icons.devices_outlined);
      case 'impots':
        return Icon(Icons.attach_money_outlined);
      case 'frais bancaires':
        return Icon(Icons.account_balance_outlined);
      default:
        return Icon(Icons.error_outline);
    }
  }
}
