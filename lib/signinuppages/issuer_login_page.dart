import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:certy_chain_nrb/signinuppages/forgotpw.dart';
import 'package:certy_chain_nrb/UIs/Issuer/issuer_page.dart';
import 'package:certy_chain_nrb/signinuppages/register_page.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_outline_button.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';

class IssuerLoginPage extends StatefulWidget {
  const IssuerLoginPage({Key? key}) : super(key: key);

  @override
  _IssuerLoginPageState createState() => _IssuerLoginPageState();
}

class _IssuerLoginPageState extends State<IssuerLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        _emailController.clear();
        _passwordController.clear();
        return true;
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: screenHeight * 0.12,
            backgroundColor: Colors.white,
            title: Center(
              child: Image.asset(
                'assets/certychainlogo.png',
                width: screenHeight * 0.3,
                height: screenHeight * 0.1,
              ),
            ),
          ),
          body: Container(
            color: Color(0XFF2E3F42),
            child: ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(screenHeight * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.02),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            spreadRadius: screenHeight * 0.006,
                            blurRadius: screenHeight * 0.006,
                            offset: Offset(0, screenHeight * 0.003),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.027,
                          horizontal: screenHeight * 0.067,
                        ),
                        child: Form(
                          child: Column(
                            children: [
                              SizedBox(height: screenHeight * 0.067),
                              Text(
                                "Welcome, Issuer!",
                                style: TextStyle(
                                  color: Color(0xFF5691A4),
                                  fontSize: screenHeight * 0.0507,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text('Sign in to access your account.'),
                              SizedBox(
                                height: screenHeight * 0.067,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: screenHeight * 0.0134),
                                  Text('Username/Email'),
                                ],
                              ),
                              CustomTextFormField(
                                controller: _emailController,
                                hintText: 'Username/Email',
                                obscureText: false,
                              ),
                              SizedBox(
                                height: screenHeight * 0.0134,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: screenHeight * 0.0134),
                                  Text('Password'),
                                ],
                              ),
                              CustomTextFormField(
                                controller: _passwordController,
                                hintText: 'Password',
                                obscureText: true,
                                suffixIcon: Icons.visibility,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.0134,
                                  horizontal: screenHeight * 0.0134,
                                ),
                                child: Custom__Button(
                                  buttonText: 'Login',
                                  onPressed: () async {
                                    try {
                                      UserCredential userCredential =
                                          await _auth
                                              .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );

                                      User? user = userCredential.user;

                                      // Check user role before proceeding
                                      if (await _checkUserRole(user)) {
                                        // Show success Snackbar
                                        _showSnackbar(
                                            'Login successful', Colors.green);

                                        // Navigate to Issuer Page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Issuer_Page(),
                                          ),
                                        );
                                      } else {
                                        // Show error Snackbar for invalid role
                                        _showSnackbar('Invalid role for login.',
                                            Colors.red);
                                      }
                                    } catch (e) {
                                      // Show error Snackbar for login failure
                                      _showSnackbar(
                                          'Login failed. Check your credentials.',
                                          Colors.red);
                                      print('Issuer login error: $e');
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.0134),
                              CustomTextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                text: 'Forgot Password?',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to check user role
  Future<bool> _checkUserRole(User? user) async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          String role = userDoc.get('role');
          return role == 'issuer';
        }
      } catch (e) {
        print('Error checking user role: $e');
      }
    }
    return false; // Default to false in case of an error
  }

  // Function to show a Snackbar
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
