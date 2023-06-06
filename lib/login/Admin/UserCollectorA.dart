import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserCollector extends StatefulWidget {
  @override
  _UserCollectorState createState() => _UserCollectorState();
}

class _UserCollectorState extends State<UserCollector> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String selectedRole = '';

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
      body: Column(
        children: [
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

                    String name = userData?['Name'] ?? 'N/A';
                    String email = userData?['email'] ?? 'N/A';
                    String role = userData?['Role'] ?? 'Employé';
                    if (role == 'Citoyen') {
                      return SizedBox();
                    }

                    Color cardColor;
                    Color textColor;
                    late AssetImage avatarImage;

                    if (role == 'Admin') {
                      cardColor = Color.fromARGB(255, 53, 183, 239);
                      textColor = Colors.white;
                      avatarImage = AssetImage('assets/adminavatar.png');
                    } else if (role == 'Emp') {
                      cardColor = Color.fromARGB(180, 41, 200, 184);
                      textColor = Colors.white;
                      avatarImage = AssetImage('assets/avatar_male.png');
                    } else {
                      cardColor = Colors.white;
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
                          backgroundImage: avatarImage,
                        ),
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
                              color: Colors.black,
                              onPressed: () async {
                                String uid = document.id;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Supprimer l'utilisateur"),
                                      content: Text(
                                          "Voulez-vous supprimer l'utilisateur ?"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Annuler"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text("Confirmer"),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            bool collectionExists =
                                                await checkCollectionExists(
                                                    uid);
                                            if (collectionExists) {
                                              await deleteAllDocumentsInCollection(
                                                  uid);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text('Supprimer l'
                                                      'utilisateur'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Utilisateur non trouvé!'),
                                                  duration:
                                                      Duration(seconds: 2),
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
                              color: Colors.black,
                              onPressed: () {
                                String uid = document.id;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text("Modifier le rôle"),
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
                                                      selectedRole =
                                                          value.toString();
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
                                                      selectedRole =
                                                          value.toString();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Annuler"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              child: Text("Confirmer"),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                bool collectionExists =
                                                    await checkCollectionExists(
                                                        uid);
                                                if (collectionExists) {
                                                  await updateRole(
                                                      uid, selectedRole);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Rôle mis à jour'),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Utilisateur non trouvé!'),
                                                      duration:
                                                          Duration(seconds: 2),
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
          ),
        ],
      ),
    );
  }

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
    CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('Documents');
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  Future<void> updateRole(String uid, String role) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'Role': role});
    } catch (e) {
      print(e);
    }
  }
}
