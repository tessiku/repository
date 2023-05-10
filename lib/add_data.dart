import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ins_app/modify_data.dart';

class AddData extends StatefulWidget {
  final String collectionName;

  AddData({required this.collectionName});

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final _formKey = GlobalKey<FormState>();
  String _selectedNombre_p = '1-2 personnes';
  String _selectedProfession = 'cadres et professions libérales supérieures';
  String _selectedType = 'National';
  String _selectedZone = 'Grand Tunis';
  final nombre_p=['1-2 personnes','3-4 personnes','5-6 personnes','7-8 personnes','9+ personnes'];
  final professions = ['cadres et professions libérales supérieures',	'cadres et professions libérales moyens',	'autres employés',	'patrons des petits métiers dans l''industrie',	'artisans et indépendants des petits métiers','	ouvriers non agricoles'	,'exploitants agricoles'	,'Ouvriers agricoles'	,'Chômeurs'	,'Retraités'	,'Autres inactifs'];
  final types = ['National', 'Communal', 'non Communal'];
  final zones = ['Grand Tunis',	'Nord Est',	'Nord ouest',	'Centre Est',	'Centre Ouest',	'Sud Est',	'Sud Ouest'	];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addData() async {
  if (_formKey.currentState!.validate()) {
    final docSnapshot = await firestore.collection(widget.collectionName).doc('General info').get();
    final docID = docSnapshot.id;

    await firestore.collection(widget.collectionName).doc(docID).set({
      'nombre_p': _selectedNombre_p,
      'profession': _selectedProfession,
      'type': _selectedType,
      'zone': _selectedZone,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data added successfully!')),
    );
  }
  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ModifyData()),
        );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _selectedNombre_p,
                onChanged: (value) {
                  setState(() {
                    _selectedNombre_p = value.toString();
                  });
                },
                items: nombre_p.map((nombre_p) {
                  return DropdownMenuItem(
                    value: nombre_p,
                    child: Text(nombre_p),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Profession',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _selectedProfession,
                onChanged: (value) {
                  setState(() {
                    _selectedProfession = value.toString();
                  });
                },
                items: professions.map((profession) {
                  return DropdownMenuItem(
                    value: profession,
                    child: Text(profession),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Profession',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value.toString();
                  });
                },
                items: types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Type',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _selectedZone,
                onChanged: (value) {
                  setState(() {
                    _selectedZone = value.toString();
                  });
                },
                items: zones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(zone),
                  );
                }).toList(),
                decoration: InputDecoration(
                 labelText: 'Zone',
contentPadding: EdgeInsets.symmetric(
vertical: 8.0,
horizontal: 16.0,
),
border: OutlineInputBorder(),
),
),
SizedBox(height: 16.0),
ElevatedButton(
onPressed: addData,
child: Text('Add'),
),
],
),
),
),
);
}
}