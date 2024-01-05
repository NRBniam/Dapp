import 'package:certy_chain_nrb/signinuppages/verifer_login_page.dart';
import 'package:flutter/material.dart';

import 'package:certy_chain_nrb/UIs/Verifier/verifier_page.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../custom_widgets/custom_outline_button.dart';

class register_page extends StatefulWidget {
  const register_page({Key? key}) : super(key: key);

  @override
  _register_pageState createState() => _register_pageState();
}

class _register_pageState extends State<register_page> {
  DateTime? selectedDate;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String errorMessage = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
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
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(screenHeight * 0.025),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenHeight * 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: screenHeight * 0.0065,
                          blurRadius: screenHeight * 0.01,
                          offset: Offset(0, screenHeight * 0.003),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.1),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.04),
                          Text(
                            "Create New",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenHeight * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Account",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenHeight * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already Registered?'),
                              CustomTextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          verifier_login_page(),
                                    ),
                                  );
                                },
                                text: 'Login',
                              ),
                              Text('Here.'),
                            ],
                          ),
                          Container(
                            height: 1.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Row(
                            children: [
                              SizedBox(width: screenWidth * 0.01),
                              Text('Name'),
                            ],
                          ),
                          CustomTextFormField(
                            hintText: 'Enter your Name',
                            controller: _nameController,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(width: screenWidth * 0.01),
                              Text('Email'),
                            ],
                          ),
                          CustomTextFormField(
                            hintText: 'Email',
                            controller: _emailController,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(width: screenWidth * 0.01),
                              Text('Password'),
                            ],
                          ),
                          CustomTextFormField(
                              hintText: 'Password',
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: Icons.visibility),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(width: screenWidth * 0.01),
                              Text('Confirm Password'),
                            ],
                          ),
                          CustomTextFormField(
                              hintText: 'Confirm Password',
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              suffixIcon: Icons.visibility),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(width: screenWidth * 0.01),
                              Text('Date of Birth'),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: selectedDate != null
                                      ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                                      : 'Select Date',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Custom__Button(
                                buttonText: 'Register',
                                onPressed: _registerUser),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _registerUser() async {
    try {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty ||
          selectedDate == null) {
        setState(() {
          errorMessage = 'Please fill in all the fields.';
        });
        return;
      }

      if (!isPasswordValid(_passwordController.text)) {
        showStyledSnackBar(
          context,
          'Password should be at least 6 characters long and contain a mix of letters and numbers.',
          Colors.red,
        );
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          errorMessage = 'Passwords do not match.';
        });
        return;
      }

      setState(() {
        errorMessage = '';
      });

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'dob': selectedDate != null
            ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
            : null,
      });

      print("User registered successfully!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => verifier_login_page(),
        ),
      );

      showStyledSnackBar(
        context,
        'Registration successful! Please log in.',
        Colors.green,
      );
    } catch (e) {
      print("Error during registration: $e");

      setState(() {
        errorMessage = 'Registration failed. Please try again.';
      });

      showStyledSnackBar(
        context,
        'Registration failed. Please try again.',
        Colors.red,
      );
    }
  }

  bool isPasswordValid(String password) {
    return password.length >= 6 &&
        RegExp(r'[a-zA-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  void showStyledSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
