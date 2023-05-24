import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_app/Pages1/StatsPage.dart';
import 'package:ins_app/login/Admin/UserCollectorA.dart';
import 'package:ins_app/login/HomePageLoginA.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _selectedRole = "Emp";
  final List<String> roles = ["Emp", "Admin", "Citoyen"];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          ' Ajouter un utilisateur',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Image.asset(
                    'assets/newUser.png',
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField(
                  value: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value.toString();
                    });
                  },
                  items: roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: Text('Ajouter un utilisateur'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 94, 6, 247)),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(double.infinity, 50)),
                        ),
                      ),
                SizedBox(height: 8.0),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    // Validate input fields
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    // Send a POST request to the registration API
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateProfile(
          displayName:
              _firstNameController.text + ' ' + _lastNameController.text,
        );

        await user.reload();
      }

      // Store user data in Firestore collection "users"
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'email': _emailController.text,
        'Name': _firstNameController.text + ' ' + _lastNameController.text,
        'lastLogin': DateTime.now(),
        'Role': _selectedRole,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserCollector(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
