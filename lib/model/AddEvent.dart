import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddEvent extends StatefulWidget {
  final DateTime selectedDate;
  final String eventName;

  AddEvent({required this.selectedDate, required this.eventName});

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  late DateTime _selectedDateTime;
  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event')),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventName = value!;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Event Date'),
                  Text(DateFormat.yMd().format(widget.selectedDate)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () async {
                  final selectedDateTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedDateTime != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        widget.selectedDate.year,
                        widget.selectedDate.month,
                        widget.selectedDate.day,
                        selectedDateTime.hour,
                        selectedDateTime.minute,
                      );
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Event Time'),
                    Text(DateFormat.jm().format(_selectedDateTime)),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newAppointment = Appointment(
                      startTime: _selectedDateTime,
                      endTime: _selectedDateTime.add(Duration(hours: 1)),
                      subject: _eventName,
                      color: Colors.blue,
                    );
                    Navigator.pop(context, newAppointment);
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
