import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegionCitoyen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          'Citoyens par région',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
        future: getGroupedDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          Map<String, List<QueryDocumentSnapshot>> groupedDocuments =
              snapshot.data!;

          return ListView.builder(
            itemCount: groupedDocuments.length,
            itemBuilder: (context, index) {
              final zone = groupedDocuments.keys.toList()[index];
              final zoneDocuments = groupedDocuments[zone]!;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Color.fromARGB(216, 208, 73, 154),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Zone: $zone',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: zoneDocuments.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = zoneDocuments[index];

                        return ListTile(
                          tileColor: Colors.white,
                          title: Text("CIN : ${document.id}"),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<String, List<QueryDocumentSnapshot>>> getGroupedDocuments() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Citoyen').get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    Map<String, List<QueryDocumentSnapshot>> groupedDocuments = {};

    for (var doc in documents) {
      CollectionReference dataCollection = FirebaseFirestore.instance
          .collection('Citoyen')
          .doc(doc.id)
          .collection('data');

      DocumentSnapshot generalInfoSnapshot =
          await dataCollection.doc('General info').get();

      if (generalInfoSnapshot.exists) {
        Map<String, dynamic>? generalInfoData =
            generalInfoSnapshot.data() as Map<String, dynamic>?;

        String? zone = generalInfoData?['zone'] as String?;

        if (zone != null) {
          if (groupedDocuments.containsKey(zone)) {
            groupedDocuments[zone]!.add(doc);
          } else {
            groupedDocuments[zone] = [doc];
          }
        }
      }
    }

    return groupedDocuments;
  }
}
