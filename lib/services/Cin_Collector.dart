import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Data_View.dart';

class cin_Collector extends StatefulWidget {
  @override
  _cin_CollectorState createState() => _cin_CollectorState();
}

class _cin_CollectorState extends State<cin_Collector> {
  late Stream<QuerySnapshot> _stream;
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setupStream() {
    _stream = FirebaseFirestore.instance.collection('Citoyen').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
          width: 150,
          child: Transform.scale(
            scale: 1,
            child: Text(
              'Recherche par CIN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by CIN',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {}); // Trigger a rebuild when the text changes
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                // Filter documents based on search input
                List<QueryDocumentSnapshot> filteredDocuments = documents
                    .where((document) => document.id
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = filteredDocuments[index];

                    return Card(
                      child: ListTile(
                        title: Text(document.id), // Display the document ID
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Deletion"),
                                      content: Text(
                                          "Are you sure you want to delete this document?"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text("Delete"),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            String cin =
                                                filteredDocuments[index].id;
                                            bool collectionExists =
                                                await checkCollectionExists(
                                                    cin);
                                            if (collectionExists) {
                                              await deleteAllDocumentsInCollection(
                                                  cin);
                                              _showSnackBar(
                                                  'Document deleted!');
                                            } else {
                                              _showSnackBar(
                                                  'Document not found!');
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.green,
                              onPressed: () {
                                // Handle edit icon tap
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Data_View(cin: document.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkCollectionExists(String cin) async {
    bool exists = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Citoyen').doc(cin).get();
      exists = snapshot.exists;
    } catch (e) {
      print(e);
    }
    return exists;
  }

  Future<void> deleteAllDocumentsInCollection(String cin) async {
    try {
      CollectionReference citoyenCollectionRef =
          FirebaseFirestore.instance.collection('Citoyen');

      // Get the reference to the "Citoyen" document
      DocumentReference citoyenDocumentRef = citoyenCollectionRef.doc(cin);

      // Get the reference to the "data" subcollection of the "Citoyen" document
      CollectionReference dataCollectionRef =
          citoyenDocumentRef.collection('data');

      // Get the reference to the "UID" document inside the "data" subcollection
      DocumentReference uidDocumentRef = dataCollectionRef.doc('UID');

      // Get the UID value from the "UID" document
      DocumentSnapshot<Object?> uidSnapshot = await uidDocumentRef.get();
      String? uid =
          (uidSnapshot.data() as Map<String, dynamic>?)?['uid'] as String?;

      if (uid != null) {
        // Delete the document from the "users" collection using the UID
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      }

      // Delete the "Citoyen" document
      await citoyenDocumentRef.delete();
    } catch (e) {
      print(e);
    }
  }

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
