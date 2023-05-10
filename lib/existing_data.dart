import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExistingData extends StatefulWidget {
  @override
  _ExistingDataState createState() => _ExistingDataState();
}

class _ExistingDataState extends State<ExistingData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();
  List<String> _docIds = [];

  Future<List<String>> checkCollectionExists(String cin) async {
    try {
      final collectionRef = firestore.collection(cin);
      final collectionSnapshot = await collectionRef.get();
      if (collectionSnapshot.docs.isNotEmpty) {
        // Collection exists and has documents
        // Retrieve document IDs in collection
        final docs = collectionSnapshot.docs;
        final docIds = docs.map((doc) => doc.id).toList();
        return docIds;
      } else {
        // Collection exists but has no documents
        // Handle as desired
        return [];
      }
    } catch (e) {
      // Collection doesn't exist
      // Handle as desired
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Collections'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _cinController,
                decoration: InputDecoration(labelText: 'CIN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CIN';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final cin = _cinController.text.trim();
                    final docIds = await checkCollectionExists(cin);
                    setState(() {
                      _docIds = docIds;
                    });
                  }
                },
                child: Text('Check'),
              ),
              SizedBox(height: 32.0),
              if (_docIds.isNotEmpty)
                Text(
                  'Document IDs in collection:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              Column(
                children: _docIds.map((docId) => Text(docId)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
