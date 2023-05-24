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
          child: Transform.scale(scale: 1.5, child: Icon(Icons.verified_user)),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

              String name = userData?['Name'] ?? 'N/A'; // Access Name field
              String email = userData?['email'] ?? 'N/A'; // Access email field
              String role = userData?['Role'] ?? 'Employé'; // Access role field

              Color cardColor;
              if (role == 'Admin') {
                cardColor = Color.fromARGB(166, 232, 46, 46);
              } else if (role == 'Citoyen') {
                cardColor = Colors.green;
              } else if (role == 'employé') {
                cardColor = Colors.blue;
              } else {
                cardColor = Color.fromARGB(201, 30, 27, 222);
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
                  leading: Icon(Icons.person), // Person icon
                  title: Text(name), // Display the name
                  subtitle: Text(email), // Display the email
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text(
                                  "Are you sure you want to delete this user?",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Delete"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      String uid = documents[index].id;
                                      bool collectionExists =
                                          await checkCollectionExists(uid);
                                      if (collectionExists) {
                                        await deleteAllDocumentsInCollection(
                                            uid);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('User deleted!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('User not found!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String selectedRole = role;
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return AlertDialog(
                                    title: Text("Update Role"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text("Employé"),
                                          leading: Radio(
                                            value: "Emp",
                                            groupValue: selectedRole,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRole = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("Admin"),
                                          leading: Radio(
                                            value: "Admin",
                                            groupValue: selectedRole,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRole = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("Citoyen"),
                                          leading: Radio(
                                            value: "Citoyen",
                                            groupValue: selectedRole,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRole = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Confirm"),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          String uid = documents[index].id;
                                          bool collectionExists =
                                              await checkCollectionExists(uid);
                                          if (collectionExists) {
                                            await updateRole(uid, selectedRole);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('Role updated!'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('User not found!'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
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
    );
  }
}
