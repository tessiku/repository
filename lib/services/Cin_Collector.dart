import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/data_view.dart';

import 'Data_View.dart'; // show the list of all the target person  //

class Cin_Collector extends StatefulWidget {
  @override
  _Cin_CollectorState createState() => _Cin_CollectorState();
}

class _Cin_CollectorState extends State<Cin_Collector> {
  late Stream<QuerySnapshot> _stream;
  TextEditingController _searchController = TextEditingController();

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
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text('Document deleted!'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Document not found!'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
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
                              builder: (context) => Data_View(
                                cin: document.id,
                              ),
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
    await FirebaseFirestore.instance.collection('Citoyen').doc(cin).delete();
  }
}
