import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ins_app/Pages1/AccountPage.dart';
import 'package:ins_app/Pages1/HomePage.dart';
import 'package:ins_app/Signup.dart';
import 'package:ins_app/login/HomePageLogin.dart';
import '../ani/BgAnimation.dart';
import 'PwdR.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String _errorMessage = '';
  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Fetch user document from Firestore
        String userId = userCredential.user!.uid;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          // Extract email, password, and role from user document
          String email = userSnapshot['email'];
          //String password = userSnapshot['password'];
          String role = userSnapshot['Role'];

          // Update login date in Firestore
          if (role == 'Emp') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePageLogin(),
              ),
            );
          } else if (role == 'Adm') ///// admin login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AccountPage(),
              ),
            );
        } else {
          setState(() {
            _errorMessage = 'User document not found';
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          setState(() {
            _errorMessage = 'Invalid email or password';
          });
        } else {
          setState(() {
            _errorMessage = e.message!;
          });
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please fix the errors in red before submitting.';
        _isLoading = false;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //backgroundColor: Color.fromARGB(255, 94, 6, 247),
        backgroundColor: Color.fromARGB(175, 122, 3, 3),
        body: Stack(
          children: [
            //CircularParticleScreen2(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset("assets/insSplash.jpg",
                                fit: BoxFit.cover),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sign In",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 24,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            child: TextFormField(
                              controller: _emailController,
                              obscureText: false,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1),
                                ),
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(0, 255, 255, 255),
                                isDense: false,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                              ),
                              validator: _validateEmail,
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              color: Color(0xff000000),
                            ),
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: BorderSide(
                                    color: Color(0xff9e9e9e), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: BorderSide(
                                    color: Color(0xff9e9e9e), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 1),
                              ),
                              labelText: "Mot de passe",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(0, 255, 255, 255),
                              isDense: false,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                            validator: _validatePassword,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Text(
                                  "Forgot Password ?",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PasswordReset()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    _authenticate();
                                  },
                                  color: Color.fromARGB(183, 1, 208, 254),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  textColor: Color.fromRGBO(255, 255, 255, 1),
                                  height: 40,
                                  minWidth: 140,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ));
  }
}
