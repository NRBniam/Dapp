import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for clipboard functionality

class AboutMePage extends StatefulWidget {
  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Email address for feedback
  final String feedbackEmail = 'certychain@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'About me - CertyChain',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.bold), // Custom font
        ),
        backgroundColor: Color(0XFF2E3F42), // Custom color
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                // Logo with a bounce animation
                _buildBounceAnimation(
                  Image.asset(
                    'assets/certychainlogo.png',
                    width: 150,
                    height: 100,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to CertyChain',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF2E3F42), // Custom color
                      fontFamily: 'OpenSans', // Custom font
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'CertyChain is a revolutionary platform that leverages blockchain technology to securely store and manage certificates. Our platform ensures the integrity and authenticity of certificates, providing numerous advantages over traditional methods.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800], // Custom color
                      fontFamily: 'OpenSans', // Custom font
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                // Divider
                Divider(
                  height: 20.0,
                  color: Colors.grey[400],
                  thickness: 2.0,
                ),
                SizedBox(height: 20.0),
                // Blockchain image with a fade animation

                SizedBox(height: 20.0),
                // Divider
                Divider(
                  height: 20.0,
                  color: Colors.grey[400],
                  thickness: 2.0,
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Advantages of CertyChain',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF2E3F42), // Custom color
                      fontFamily: 'OpenSans', // Custom font
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAdvantage('1. Security',
                          'Certificates are securely stored on the blockchain, making them tamper-proof and resistant to fraud.'),
                      _buildAdvantage('2. Transparency',
                          'The blockchain provides a transparent and immutable record of certificate issuance and verification.'),
                      _buildAdvantage('3. Accessibility',
                          'Certificates can be accessed anytime, anywhere, reducing the need for physical copies and manual verification.'),
                      // Add more advantages as needed
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                // Divider
                Divider(
                  height: 20.0,
                  color: Colors.grey[400],
                  thickness: 2.0,
                ),
                SizedBox(height: 20.0),
                // Blockchain advantages image with a zoom animation
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: _buildZoomAnimation(
                    Image.asset(
                      'assets/Picture1.png',
                      width: 300,
                      height: 200,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Divider
                Divider(
                  height: 20.0,
                  color: Colors.grey[400],
                  thickness: 2.0,
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'For feedback, please contact us at:',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0XFF2E3F42), // Custom color
                      fontFamily: 'OpenSans', // Custom font
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Copy email address to clipboard
                    Clipboard.setData(ClipboardData(text: feedbackEmail));
                    // Show a snackbar indicating the email has been copied
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Email copied to clipboard: $feedbackEmail'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      feedbackEmail,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0XFF2E3F42), // Custom color
                          fontFamily: 'OpenSans',
                          fontStyle: FontStyle.italic // Custom font

                          ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdvantage(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0XFF2E3F42), // Custom color
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(
                fontSize: 16.0, color: Colors.grey[800]), // Custom color
          ),
        ],
      ),
    );
  }

  // Animation widgets

  Widget _buildBounceAnimation(Widget child) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      builder: (_, double value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - value)), // Bounce up
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _buildFadeAnimation(Widget child) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1000),
      builder: (_, double value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _buildZoomAnimation(Widget child) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      builder: (_, double value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}
