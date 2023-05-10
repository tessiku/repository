import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_data.dart';

class CreateData extends StatefulWidget {
  final String cin;

  CreateData(this.cin);

  @override
  _CreateDataState createState() => _CreateDataState();
}

class _CreateDataState extends State<CreateData> {
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> checkCollectionExists(String collectionName) async {
    final collectionRef = firestore.collection(collectionName);
    final docSnapshot = await collectionRef.doc('dummy').get();

    if (docSnapshot.exists) {
      return collectionRef.id;
    } else {
      return null;
    }
  }

  void createCollection() async {
    if (_formKey.currentState!.validate()) {
      final cin = _cinController.text.trim();
      final existingCollection = await firestore.collection(cin).get();

      if (existingCollection.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collection with CIN $cin already exists!')),
        );
      } else {
        await firestore.collection(cin).doc('General info').set({});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collection $cin created successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddData(
              collectionName: cin,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _cinController.text = widget.cin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Collection'),
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
                onPressed: createCollection,
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
