import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final events = snapshot.data!.docs;
          Set<String> eventIds = Set<String>(); // Store event IDs

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index].data() as Map<String, dynamic>;
              final eventId = events[index].id; // Get event ID
              final title = event['subject'] as String;
              final startTime = (event['startTime'] as Timestamp).toDate();

              // Check if event ID already exists
              if (eventIds.contains(eventId)) {
                return Container(); // Skip duplicate event
              }

              eventIds.add(eventId); // Add event ID to set

              return ListTile(
                title: Text(title),
                subtitle: Text(startTime.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
