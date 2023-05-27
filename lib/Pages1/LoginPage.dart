import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ins_app/login/HomePageLogin.dart';
import 'package:ins_app/login/HomePageLoginA.dart';
import '../ani/BgAnimation.dart';
import '../login/HomePageLoginC.dart';
import 'PwdR.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //

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
        // Save UID to SharedPreferences
        String userId = userCredential.user!.uid;
        await saveUidToSharedPreferences(userId);

        // Fetch user document from Firestore
        String userIds = userCredential.user!.uid;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userIds)
            .get();

        if (userSnapshot.exists) {
          // Extract email, password, and role from user document
          String email = userSnapshot['email'];
          //String password = userSnapshot['password'];
          String role = userSnapshot['Role'];
          String name = userSnapshot['Name'];
          //save role to shared preferences

          // Update login date in Firestore
          if (role == 'Emp') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePageLogin(
                  userEmail: email,
                  name: name,
                ),
              ),
            );
          } else if (role == 'Admin') ///// admin login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePageLoginA(
                  userEmail: email,
                  name: name,
                ),
              ),
            );
          else if (role == 'Citoyen') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePageLoginC(
                  userEmail: email,
                  name: name,
                ),
              ),
            );
          } else {
            setState(() {
              _errorMessage = 'User document not found';
            });
          }
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

  Future<void> saveUidToSharedPreferences(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }

  /////// save role to shared preferences
  Future<void> saveRoleToSharedPreferences(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') ||
        !value.contains('.') ||
        !value.contains('gmail')) {
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
        //backgroundColor: Color.fromARGB(206, 9, 30, 224),

        body: Stack(
      children: [
        //CircularParticleScreen2(),
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/stats.jpg"),
            fit: BoxFit.cover,
          )),
        ),
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
                        child: FractionallySizedBox(
                          widthFactor:
                              1, // Adjust this value as needed to reduce the size
                          heightFactor:
                              0.7, // Adjust this value as needed to reduce the size
                          child: Image.asset(
                            "assets/INS_T.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        " ",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 24,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        child: TextFormField(
                          controller: _emailController,
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color.fromARGB(255, 16, 16, 16), //
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
                                  color: Color.fromARGB(255, 99, 99, 99),
                                  width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 99, 99, 99),
                                  width: 1),
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              color: Color.fromARGB(255, 5, 5, 5),
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
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 5, 5, 5), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 99, 99, 99),
                                width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 99, 99, 99),
                                width: 1),
                          ),
                          labelText: "Mot de passe",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(0, 255, 255, 255),
                          isDense: false,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                color: Color.fromARGB(255, 6, 6, 6),
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
                              onPressed: () async {
                                _authenticate();

                                final SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.setString(
                                    'email', _emailController.text);
                              },
                              color: Color.fromARGB(121, 232, 232, 232),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "connectez",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              textColor: Color.fromRGBO(6, 6, 6, 1),
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

Future<String?> getSavedUidFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}

Future<String?> getSavedRoleFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}
