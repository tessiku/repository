import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/services/Display_Data_Docs.dart';

class Data_View extends StatelessWidget {
  final String cin;

  Data_View({required this.cin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Container(
          width: 200,
          child: Transform.scale(
            scale: 1,
            child: Text(
              'Donées de $cin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 210,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Citoyen')
                    .doc(cin)
                    .collection('data')
                    .where(FieldPath.documentId,
                        whereIn: ['Depense', 'General info']).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No documents found'),
                    );
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: documents.map((document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        IconData? iconData = getIconData(document.id);
                        print(snapshot.data!.docs.length);
                        return Container(
                          width: 175,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Display_Data_Docs(
                                  cin: cin,
                                  documentID: document.id,
                                ),
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180.0,
                                  height: 120.0,
                                  margin: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 94, 6, 247),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    document.id,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData? getIconData(String documentId) {
    switch (documentId) {
      case 'Depense':
        return Icons.attach_money;
      case 'General info':
        return Icons.info;
      // Add more cases for other icons as needed
      default:
        return null;
    }
  }
}
