

import 'package:flutter/material.dart';
import 'package:ins_app/model/AddEvent.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key,required this.name , required this.userEmail}) : super(key: key);
  final String name;
  final String userEmail;
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _calendarController = CalendarController();
  CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            child: TableCalendar(
              calendarController: _calendarController,
              weekendDays: [6, 7],
              headerStyle: HeaderStyle(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 94, 6, 247),
                ),
                headerMargin: const EdgeInsets.only(top: 8.0),
                titleTextStyle: TextStyle(color: Colors.white),
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              events: {},
              onDaySelected: (date, events, holidays) {
                setState(() {}); // Refresh the UI when a day is selected
              },
            ),
          ),
          SizedBox(height: 20),
          Flexible(
            child: FutureBuilder<QuerySnapshot>(
              future: eventsCollection.where('events').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load events'),
                  );
                }

                final events = snapshot.data!.docs;

                if (events.isEmpty) {
                  return Center(
                    child: Text('pas d\'evenements pour le moment'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index].data() as Map<String, dynamic>;
                    final eventId = events[index].id;
                    final title = event['titre'] as String;
                    final date = event['date'] as String;
                    final time = event['time'] as String;

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.cyan,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(date),
                            Text(time),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 100,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          onPressed: () {
            final selectedDate = _calendarController.selectedDay;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEvent(selectedDate: selectedDate , name: widget.name , userEmail: widget.userEmail),
              ),
            );
          },
          backgroundColor: Color.fromARGB(255, 94, 6, 247),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " + Ajouter  ",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
