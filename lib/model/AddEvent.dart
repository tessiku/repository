import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ins_app/login/Work/DeletePage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEvent extends StatefulWidget {
  final DateTime selectedDate;

  const AddEvent({required this.selectedDate});
  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titel = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _date = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void AddEv() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await firestore.collection("events").add({
        "titre": _titel.text,
        "description": _description.text,
        "date": _date.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
          width: 100,
          height: 100,
          child: Transform.scale(scale: 1.5, child: Icon(Icons.event)),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Form(
            key: _formKey,
            child: FormBuilder(
                child: Column(
              children: [
                FormBuilderTextField(
                  controller: _titel,
                  name: "titre",
                  decoration: InputDecoration(
                    hintText: 'ajouter un titre pour votre evenement',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 48.0),
                  ),
                ),
                Divider(),
                FormBuilderTextField(
                  controller: _description,
                  name: "description",
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ajouter une description pour votre evenement',
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                Divider(),
                FormBuilderDateTimePicker(
                  controller: _date,
                  name: "date",
                  initialValue: widget.selectedDate,
                  fieldHintText: "ajouter un date",
                  inputType: InputType.date,
                  format: DateFormat("EEEE, MMMM d, yyyy"),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today_sharp),
                  ),
                ),
                Divider(),
                ElevatedButton(
                    onPressed: () async {
                      AddEv();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeletePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 94, 6, 247),
                      minimumSize: Size(150, 50),
                    ),
                    child: Text('ajouter')),
              ],
            )),
          )
        ],
      ),
    );
  }
}
