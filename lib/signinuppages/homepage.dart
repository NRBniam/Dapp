import 'package:certy_chain_nrb/signinuppages/aboutme.dart';
import 'package:certy_chain_nrb/signinuppages/verifer_login_page.dart';
import 'package:certy_chain_nrb/signinuppages/issuer_login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.15,
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset(
            'assets/certychainlogo.png',
            width: screenHeight * 0.3,
            height: screenHeight * 0.15,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [Colors.white, Color(0xFF2E3F42)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: screenHeight * 0.15,
                  backgroundColor: Color(0xFF2E3F42),
                  child: Icon(Icons.dataset_linked,
                      size: screenHeight * 0.2,
                      color: Colors.white // Adjust color as needed
                      )),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Welcome to CertyChain',
                style: TextStyle(
                  fontSize: screenHeight * 0.032,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3F42),
                ),
              ),
              SizedBox(height: screenHeight * 0.067),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => verifier_login_page(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color(0xFF2E3F42),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenHeight * 0.027,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenHeight * 0.04,
                    ),
                  ),
                ),
                icon: Image.asset(
                  'assets/certificate.png',
                  width: screenHeight * 0.03,
                  height: screenHeight * 0.03,
                ),
                label: Text('I am Verifier'),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IssuerLoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color(0xFF2E3F42),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenHeight * 0.027,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenHeight * 0.04,
                    ),
                  ),
                ),
                icon: Icon(Icons.assignment_add),
                label: Text('I am Issuer'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutMePage(),
            ),
          );
        },
        backgroundColor: Color(0xFF2E3F42),
        icon: Icon(
          Icons.info,
          color: Colors.white,
        ),
        label: Text(
          'About Me',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
