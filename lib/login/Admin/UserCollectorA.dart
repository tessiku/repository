import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ins_app/data_view.dart';

class UserCollector extends StatefulWidget {
  @override
  _UserCollectorState createState() => _UserCollectorState();
}

class _UserCollectorState extends State<UserCollector> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<bool> checkCollectionExists(String uid) async {
    bool exists = false;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      exists = snapshot.exists;
    } catch (e) {
      print(e);
    }
    return exists;
  }

  Future<void> deleteAllDocumentsInCollection(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  Future<void> updateRole(String uid, String role) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'Role': role});
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
            child:
                Transform.scale(scale: 1.5, child: Icon(Icons.verified_user)),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Votre liste des utilisateurs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = documents[index];
                    Map<String, dynamic>? userData =
                        document.data() as Map<String, dynamic>?;

                    String name =
                        userData?['Name'] ?? 'N/A'; // Access Name field
                    String email =
                        userData?['email'] ?? 'N/A'; // Access email field
                    String role =
                        userData?['Role'] ?? 'Employé'; // Access role field

                    Color cardColor;
                    Color textColor;
                    if (role == 'Admin') {
                      cardColor = Color.fromRGBO(54, 122, 231, 0.675);
                      textColor = Colors.white;
                    } else if (role == 'Emp') {
                      cardColor = Color.fromARGB(126, 1, 38, 69);
                      textColor = Colors.white;
                    } else {
                      cardColor = Color.fromARGB(198, 242, 211, 211);
                      textColor = Colors.black;
                    }

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assets/adduser.png'),
                        ), // Person icon
                        title: Text(
                          name,
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          email,
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                // Delete user logic
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Update role logic
                              },
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]));
  }
}
