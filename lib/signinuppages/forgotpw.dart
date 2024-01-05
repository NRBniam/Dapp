import 'package:flutter/material.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.15,
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset(
            'assets/certychainlogo.png',
            width: screenWidth * 0.5,
            height: screenHeight * 0.1,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email to reset your password',
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.016),
            CustomTextFormField(
              hintText: 'Email',
              controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your email';
                }
                return '';
              },
            ),
            SizedBox(height: screenHeight * 0.016),
            Custom__Button(
              buttonText: 'Reset Password',
              onPressed: () {
                _resetPassword(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Password reset email sent. Check your inbox.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );
    } catch (e) {
      // Handle reset password error
      print("Error during password reset: $e");

      // Show an error message to the user if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error resetting password. Please try again.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
  }
}
