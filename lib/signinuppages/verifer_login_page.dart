import 'package:certy_chain_nrb/signinuppages/aboutme.dart';
import 'package:certy_chain_nrb/signinuppages/forgotpw.dart';

import 'package:flutter/material.dart';
import 'package:certy_chain_nrb/UIs/Issuer/issuer_page.dart';
import 'package:certy_chain_nrb/signinuppages/register_page.dart';
import 'package:certy_chain_nrb/UIs/Verifier/verifier_page.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_outline_button.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class verifier_login_page extends StatefulWidget {
  const verifier_login_page({Key? key}) : super(key: key);

  @override
  _verifier_login_pageState createState() => _verifier_login_pageState();
}

class _verifier_login_pageState extends State<verifier_login_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorText = ''; // to store error text

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed to avoid memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Clear controllers when user tries to leave the page
        _emailController.clear();
        _passwordController.clear();
        return true; // Allow the page to be popped
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: screenHeight * 0.15,
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
                Container(
                  child: Column(
                    children: [],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(screenHeight * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.03),
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
                              SizedBox(height: screenHeight * 0.06),
                              Text(
                                "Let's Go",
                                style: TextStyle(
                                  color: Color(0xFF5691A4),
                                  fontSize: screenHeight * 0.0507,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Sign-in to Continue.',
                                style: TextStyle(
                                  color: Color(0xFF5691A4),
                                  fontSize: screenHeight * 0.017,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                      );

                                      // If login is successful, show SnackBar and navigate after 2 seconds
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Colors.green, // Background color
                                          content: Row(
                                            children: [
                                              Icon(Icons.check,
                                                  color: Colors
                                                      .white), // Icon for success
                                              SizedBox(width: 10),
                                              Text(
                                                'Login Successful',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );

                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Verifier_Page(),
                                          ),
                                        );
                                      });
                                    } catch (e) {
                                      // Handle login errors
                                      print("Error: $e");

                                      // Update error text
                                      setState(() {
                                        _errorText =
                                            'Invalid username or password';
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors
                                                .red, // Background color for error
                                            content: Row(
                                              children: [
                                                Icon(Icons.error,
                                                    color: Colors
                                                        .white), // Icon for error
                                                SizedBox(width: 10),
                                                Text(
                                                  'Login Failed: Invalid Credentials',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                              // Show error text if exists
                              if (_errorText.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.0134,
                                    horizontal: screenHeight * 0.0134,
                                  ),
                                  child: Text(
                                    _errorText,
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
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
                              SizedBox(height: screenHeight * 0.01),
                              Text('Dont have an account?'),
                              Padding(
                                padding: EdgeInsets.all(screenHeight * 0.0134),
                                child: Custom__Button(
                                  buttonText: 'Register',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => register_page(),
                                      ),
                                    );
                                  },
                                ),
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
}
