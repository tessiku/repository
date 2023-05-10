/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DeleteTest extends StatefulWidget {
  final FirebaseFirestore firestore;

  DeleteTest(this.firestore);

  @override
  _DeleteTestState createState() => _DeleteTestState();
}

class _DeleteTestState extends State<DeleteTest> {
  final _formKey = GlobalKey<FormState>();
  final _cinController = TextEditingController();
  List<QueryDocumentSnapshot> _documents = [];

  @override
  void dispose() {
    _cinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _cinController,
              decoration: InputDecoration(
                hintText: 'Enter CIN to delete',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  String cin = _cinController.text;
                  if (cin.isNotEmpty) {
                    // Query the collection for documents with the specified CIN number
                    QuerySnapshot querySnapshot = await widget.firestore
                        .collection(_cinController.text)
                        .where('cin', isEqualTo: cin)
                        .get();

                    setState(() {
                      _documents = querySnapshot.docs;
                    });

                    // Clear the form field
                    _cinController.clear();
                  }
                },
                child: Text('Search'),
              ),
            ),
            _documents.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _documents.length,
                      itemBuilder: (context, index) {
  var documentSnapshot = _documents[index];
  var data = documentSnapshot.data();
  var fields = data!.keys.toList()..remove('cin');
  return Card(
    child: Column(
      children: [
        ListTile(
          title: Text('Document ID: ${documentSnapshot.id}'),
          subtitle: Text('CIN: ${data!['cin']}'),
        ),
        ...fields.map((key) => ListTile(
              title: Text('$key: ${data![key]}'),
              trailing: IconButton(
  icon: Icon(Icons.delete),
  onPressed: () async {
    // Delete the specified field from the document
    await documentSnapshot.reference.update({
      key: FieldValue.delete(),
    });
    setState(() {
  data?.remove(key);
});

    });
  },
),

            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              // Delete the entire document
              await documentSnapshot.reference.delete();
              setState(() {
                _documents.removeAt(index);
              });
            },
            child: Text('Delete Document'),
          ),
        ),
      ],
    ),
  );
},

                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
*/