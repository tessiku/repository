import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DeleteTest extends StatefulWidget {
  DeleteTest();

  @override
  _DeleteTestState createState() => _DeleteTestState();
}

class _DeleteTestState extends State<DeleteTest> {
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();

  @override
  void dispose() {
    _cinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Collection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _cinController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter CIN of collection to delete',
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    labelText: "CIN",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff9e9e9e),
                    ),
                    filled: true,
                    fillColor: Color(0x00f2f2f3),
                    isDense: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a CIN';
                    } else if (value.length != 8) {
                      return 'Please enter a valid 8-digit CIN number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16.0),
              MaterialButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Are you sure you want to delete?"),
                        content: Text("This action cannot be undone."),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: Text("Delete"),
                            style: ElevatedButton.styleFrom(
                              // Set background color to red
                              primary: Colors.red,
                            ),
                            onPressed: () async {
                              String cin = _cinController.text;
                              if (cin.isNotEmpty) {
                                // Check if the collection exists
                                bool collectionExists = await checkCollectionExists(cin);
                                if (collectionExists) {
                                  // Delete all documents in the collection
                                  await deleteAllDocumentsInCollection(cin);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('All documents in collection deleted!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Collection not found!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                                // Clear the form field
                                _cinController.clear();
                              }

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text("Delete"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to check if a collection exists
  Future<bool> checkCollectionExists(String cin) async {
    bool exists = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("Citoyen").doc(cin).get();
      exists = snapshot.exists;
    } catch (e) {
      print(e);
    }
    return exists;
  }
      // Function to delete all documents in a collection
  Future<void> deleteAllDocumentsInCollection(String cin) async {
  await FirebaseFirestore.instance.collection("Citoyen").doc(cin).delete();
}

}