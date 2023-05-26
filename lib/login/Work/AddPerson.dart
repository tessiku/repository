import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ins_app/login/HomePageLogin.dart';

import '../../services/AddGeneralInfo.dart';

class AddPerson extends StatefulWidget {
  User? getCurrentUser() {
    // jbli el inforamtion mta3 el user
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  _AddPersonState createState() => _AddPersonState();
  void userdata() async {
    var user = getCurrentUser();
    if (user != null) {
      var email = user.email;
      var name = user.displayName;
    }
  }
}

class _AddPersonState extends State<AddPerson> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cinController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _cinController = TextEditingController();
  }

  Future<String?> checkCollectionExists(String collectionName) async {
    final collectionRef = firestore.collection(collectionName);
    final docSnapshot = await collectionRef.doc('dummy').get();

    if (docSnapshot.exists) {
      return collectionRef.id;
    } else {
      return null;
    }
  }

  void createCollection() async {
    if (_formKey.currentState!.validate()) {
      final cin = _cinController.text.trim();
      if (cin.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter CIN')),
        );
      } else {
        final existingCollection = await checkCollectionExists('Citoyen');

        if (existingCollection != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The person with CIN $cin already exists!')),
          );
        } else {
          try {
            UserCredential userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );

            User? user = userCredential.user;

            if (user != null) {
              await user.updateProfile(
                displayName: _cinController.text,
              );

              await user.reload();
            }

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .set({
              'email': _emailController.text,
              'Name':
                  _firstNameController.text + ' ' + _lastNameController.text,
              'lastLogin': DateTime.now(),
              'Role': "Citoyen",
            });
            await FirebaseFirestore.instance
                .collection('Citoyen')
                .doc(cin)
                .set({});
            await FirebaseFirestore.instance
                .collection("Citoyen")
                .doc(cin)
                .collection('data')
                .doc('General info')
                .set({});
            await FirebaseFirestore.instance
                .collection("Citoyen")
                .doc(cin)
                .collection('data')
                .doc('Depense')
                .set({});
            await FirebaseFirestore.instance
                .collection("Citoyen")
                .doc(cin)
                .collection('data')
                .doc('UID')
                .set({'uid': user.uid});
          } on FirebaseAuthException catch (e) {
            setState(() {
              _errorMessage = e.message!;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'The person with CIN $cin has been created successfully!'),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddGeneralInfo(
                  cin: cin,
                ),
              ),
            );
          } on FirebaseAuthException catch (e) {
            setState(() {
              _errorMessage = e.message!;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_errorMessage),
              ),
            );
          } catch (e) {
            print(e.toString());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred. Please try again later.'),
              ),
            );
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter CIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
          width: 100,
          height: 100,
          child: Transform.scale(scale: 1.5, child: Icon(Icons.person_add)),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/family.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "créer un nouveau  citoyen",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 22,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    child: OtpTextField(
                      keyboardType: TextInputType.number,
                      numberOfFields: 8,
                      showFieldAsBox: false,
                      fieldWidth: 40,
                      filled: true,
                      fillColor: Color(0x00000000),
                      enabledBorderColor: Color(0xff898a8e),
                      focusedBorderColor: Color(0xff3a57e8),
                      borderWidth: 2,
                      margin: EdgeInsets.all(0),
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      obscureText: false,
                      borderRadius: BorderRadius.circular(4.0),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        color: Color(0xff000000),
                      ),
                      onCodeChanged: (String value) {
                        setState(() {
                          _cinController.text = value;
                        });
                      },
                      onSubmit: (String value) {
                        setState(() {
                          _cinController.text = value;
                        });
                      },
                    ),
                  ),
                  //textfield for first name
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                  //textfield for last name
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),

                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MaterialButton(
                    onPressed: createCollection,
                    color: Color.fromARGB(255, 94, 6, 247),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Ajouter un nouveau Citoyen",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                    textColor: Color(0xff3a57e8),
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
