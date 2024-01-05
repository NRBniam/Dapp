import 'package:certy_chain_nrb/UIs/vrfyr_prsnl_pg.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';
import 'package:certy_chain_nrb/signinuppages/verifer_login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// ...

void _showCertificateDetailsDialog(Map<String, dynamic> certificateData) {
  // Extract the Firestore timestamp
  Timestamp timestamp = certificateData['passOutDate'];

  // Convert the timestamp to a DateTime object
  DateTime passOutDate = timestamp.toDate();

  // Format the DateTime object as a readable string
  String formattedDate = DateFormat('yyyy-MM-dd').format(passOutDate);

  // Now, you can use `formattedDate` in your dialog
  // ...

  // Rest of your code
}

class Verifier_Page extends StatefulWidget {
  const Verifier_Page({Key? key}) : super(key: key);

  @override
  _Verifier_PageState createState() => _Verifier_PageState();
}

class _Verifier_PageState extends State<Verifier_Page> {
  int _currentIndex = 0;

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
            width: 150,
            height: 100,
          ),
        ),
      ),
      body: Center(
        child: _currentIndex == 0
            ? _buildVerifyPageContent()
            : CertyChainVerifierUI(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0XFF2E3F42),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (index == 2) {
            _showLogoutConfirmationDialog();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Verify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  TextEditingController hashController = TextEditingController();

  Widget _buildVerifyPageContent() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: CustomTextFormField(
                              controller: hashController,
                              hintText:
                                  'Enter your hash value to verify your certificate',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Positioned(
                            left: screenWidth * 0.01,
                            child: Custom__Button(
                              buttonText: 'Verify',
                              onPressed: () {
                                // Handle verification logic
                                String enteredHashCode = hashController.text;
                                _verifyCertificate(enteredHashCode);
                              },
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.04,
                                horizontal: screenWidth * 0.15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(),
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Logout Confirmation',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: Colors.grey,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                width: 0,
                color: Colors.grey,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => verifier_login_page(),
                      ),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //
  void _verifyCertificate(String enteredHashCode) async {
    try {
      // Query Firestore to check if the entered hash code exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('certificates')
          .where('uniqueHashCode', isEqualTo: enteredHashCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Hash code found, display the details
        Map<String, dynamic> certificateData =
            querySnapshot.docs[0].data() as Map<String, dynamic>;
        _showCertificateDetailsDialog(certificateData);
      } else {
        // Hash code not found, show an error message or handle accordingly
        _showErrorMessage('Invalid hash code. Please try again.');
      }
    } catch (error) {
      print('Error verifying certificate: $error');
      // Handle the error as needed
      _showErrorMessage('Error verifying certificate. Please try again.');
    }
  }

  void _showCertificateDetailsDialog(Map<String, dynamic> certificateData) {
    // Extract the Firestore timestamp
    Timestamp timestamp = certificateData['passOutDate'];

    // Convert the timestamp to a DateTime object
    DateTime passOutDate = timestamp.toDate();

    // Format the DateTime object as a readable string
    String formattedDate = DateFormat('yyyy-MM-dd').format(passOutDate);

    // Show a dialog or navigate to a new screen to display certificate details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Certificate Details',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                  'Certificate Name:', certificateData['certificateName']),
              _buildDetailRow('Assignee:', certificateData['assigneeName']),
              _buildDetailRow('Educational Institution:',
                  certificateData['institutionName']),
              _buildDetailRow('Certificate Purpose:',
                  certificateData['certificatePurpose']),
              _buildDetailRow('Passout Date:', formattedDate),
              _buildDetailRow('Signature:', certificateData['signature']),
              _buildDetailRow('', ''), // Add an empty row for spacing
              // Add more details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Color(0XFF2E3F42),
          elevation: 0,
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailDivider() {
    return Divider(
      color: Colors.grey, // Adjust the divider color
      thickness: 1.0, // Adjust the divider thickness
      height: 16.0, // Adjust the vertical space above and below the divider
    );
  }

  void _showErrorMessage(String message) {
    // Show a snackbar or any other way to display error messages
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
