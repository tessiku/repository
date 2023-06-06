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
        title: Transform.scale(
          scale: 1,
          child: Text(
            'Données de $cin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              child: Text('aucune donnée trouvée'),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              IconData? iconData = getIconData(document.id);

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 94, 6, 247),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            iconData,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          document.id,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
