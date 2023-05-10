import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ins_app/homepage.dart';
import 'package:ins_app/Signup.dart';


class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
              SizedBox(height: 16.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _authenticate,
                      child: Text('Login'),
                    ),
              SizedBox(height: 8.0),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp(),
      ),
    );
  },
  child: Text('SIGN UP'),
),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage()
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
