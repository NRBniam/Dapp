import 'package:certy_chain_nrb/UIs/Certificates/Certificate_Maker.dart';
import 'package:certy_chain_nrb/signinuppages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';

class Issuer_Page extends StatelessWidget {
  const Issuer_Page({Key? key});

  // Function to show a confirmation dialog
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout Confirmation',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0XFF2E3F42), // Set the background color
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Logout function
              },
              child: Text('Logout',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    // Add your logout logic here

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(), // Replace with your login screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
        actions: [
          // Logout button
          IconButton(
            onPressed: () => _showLogoutConfirmation(context),
            icon: Icon(Icons.logout),
            color: Color(0XFF2E3F42),
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: Color(0XFF2E3F42),
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(screenHeight * 0.025),
                    height: screenWidth * 1.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenHeight * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: screenHeight * 0.006,
                          blurRadius: screenHeight * 0.006,
                          offset: Offset(0, screenHeight * 0.003),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/authenticity.png',
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.3,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1),
                          child: Custom__Button(
                            buttonText: 'Issue a Certificate',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CertificateMakerScreen(),
                                ),
                              );
                            },
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
