import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('TAB3').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return data;
        }).toList();

        return DataView(data: data);
      },
    );
  }
}

class DataView extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  DataView({required this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Data from Firestore:',
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = data[index];
                    return ListTile(
                      title: Text(item.toString()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
