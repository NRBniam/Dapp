import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CertyChainVerifierUI extends StatefulWidget {
  @override
  _CertyChainVerifierUIState createState() => _CertyChainVerifierUIState();
}

class _CertyChainVerifierUIState extends State<CertyChainVerifierUI> {
  bool isEditing = false; // Tracks editing mode
  bool isChangingPassword = false; // Tracks password change mode
  bool passwordChanged = false; // Tracks password change success state
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String passwordError = '';
  String dataUpdateMsg = '';
  String passwordChangeMsg = '';
  String certificatePurpose = '';
  bool viewCertificatesClicked = false;
  String hashCodes = '';
  List<String> certificatePurposes = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fetchData();
  }

  void toggleEditing() => setState(() => isEditing = !isEditing);

  void togglePasswordChange() {
    passwordController
        .clear(); // Clear the password field when entering the change password mode
    setState(() {
      isChangingPassword = !isChangingPassword;
      passwordError = '';
      passwordChanged = false; // Reset the success state
    });
  }

/*
  Future<void> fetchData() async {
    try {
      // Authenticate the user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Assuming you have a 'users' collection in your Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use the user's UID as the document ID
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          setState(() {
            nameController.text = userData['name'] ?? '';
            emailController.text = userData['email'] ?? '';
          });
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
*/
  Future<void> fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          // Fetch the certificates associated with the assignee's email
          QuerySnapshot certificatesSnapshot = await FirebaseFirestore.instance
              .collection('certificates')
              .where('assigneeEmail', isEqualTo: userData['email'])
              .get();

          // Display the purpose of the first certificate found (if any)
          if (certificatesSnapshot.docs.isNotEmpty) {
            DocumentSnapshot certificateSnapshot =
                certificatesSnapshot.docs.first;
            Map<String, dynamic> certificateData =
                certificateSnapshot.data() as Map<String, dynamic>;

            // Update the UI with certificate details
            setState(() {
              certificatePurpose = certificateData['certificatePurpose'] ?? '';
              certificatePurposes = certificatesSnapshot.docs
                  .map((doc) => doc['certificatePurpose']
                      .toString()) // Adjust based on your document structure
                  .toList();
            });
          } else {
            // If no certificates found, display a message accordingly
            setState(() {
              dataUpdateMsg = 'No certificates found';
            });
          }

          // Update the user data in the UI
          setState(() {
            nameController.text = userData['name'] ?? '';
            emailController.text = userData['email'] ?? '';
          });
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  ///---
  ///
  ///
  Future<void> updateUserData() async {
    try {
      // Authenticate the user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use the user's UID as the document ID
            .update({
          'name': nameController.text,
          'email': emailController.text,
        });

        setState(() {
          dataUpdateMsg = '';
        });

        showSnackBar(
          context,
          'User data updated successfully',
          Colors.green,
        );

        print('User data updated successfully');
      }
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  Future<void> changeUserPassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String newPassword = passwordController.text;

        if (!isPasswordValid(newPassword)) {
          showSnackBar(
            context,
            'Password should be at least 6 characters long and contain a mix of letters and numbers.',
            Colors.red,
          );
          return;
        }

        await user.updatePassword(newPassword);

        // Clears the password field after a successful password change
        passwordController.clear();
        setState(() {
          passwordError = '';
          passwordChanged = true;
          passwordChangeMsg = 'Password changed successfully';
        });

        showSnackBar(
          context,
          'Password changed successfully',
          Colors.green,
        );

        print('Password changed successfully');
      }
    } catch (error) {
      print('Error changing password: $error');
      setState(() {
        passwordChangeMsg = 'Error changing password';
      });

      showSnackBar(
        context,
        'Error changing password',
        Colors.red,
      );
    }
  }

  // Function to validate password format
  bool isPasswordValid(String password) {
    // password format validation logic
    // equiring at least 6 characters and a mix of letters and numbers
    return password.length >= 6 &&
        RegExp(r'[a-zA-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  // Function to show a styled SnackBar
  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future<void> fetchCertificateDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          QuerySnapshot certificatesSnapshot = await FirebaseFirestore.instance
              .collection('certificates')
              .where('assigneeEmail', isEqualTo: userData['email'])
              .get();

          if (certificatesSnapshot.docs.isNotEmpty) {
            // Update the UI with certificate purposes
            setState(() {
              certificatePurposes = certificatesSnapshot.docs
                  .map((doc) => doc['certificatePurpose']
                      .toString()) // Adjust this line based on your document structure
                  .toList();
            });
          } else {
            // If no certificates found, display a message accordingly
            setState(() {
              dataUpdateMsg = 'No certificates found';
            });
          }
        }
      }
    } catch (error) {
      print('Error fetching certificate details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // White container with fields
            Container(
              margin: EdgeInsets.all(screenWidth * 0.05),
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: screenWidth * 0.01,
                    blurRadius: screenWidth * 0.014,
                    offset: Offset(0, screenWidth * 0.003),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Verifier - Personal Details',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Row(
                    children: [
                      Text('USER'),
                      Spacer(),
                      Text('NO. OF CERTIFICATES OWNED'),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.005),
                  Row(
                    children: [
                      Text(
                        nameController.text,
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                      Spacer(),
                      Text(
                        '21',
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  TextFormField(
                    readOnly: !isEditing,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'NAME',
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  TextFormField(
                    readOnly: true,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'EMAIL',
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  // Display Certificate Purpose
                  if (viewCertificatesClicked)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Certificate Purposes:',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder<void>(
                          future: fetchCertificateDetails(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // Display all certificate purposes
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: certificatePurposes
                                    .map(
                                      (certPurpose) => Text(
                                        '- $certPurpose',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: screenWidth * 0.02),
                  if (isChangingPassword && !passwordChanged)
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'NEW PASSWORD',
                      ),
                    ),
                  Positioned(
                    bottom: screenWidth * 0.01,
                    child: Row(
                      children: [
                        Custom__Button(
                          onPressed: () {
                            togglePasswordChange();
                            // Toggle change password mode
                          },
                          buttonText: 'Change Password',
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Custom__Button(
                            onPressed: () {
                              // Toggle the viewCertificatesClicked state when the button is clicked
                              setState(() {
                                viewCertificatesClicked =
                                    !viewCertificatesClicked;
                              });
                            },
                            buttonText: 'View Certificates',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Edit and Change Password buttons
            Positioned(
              top: screenWidth * 0.05,
              right: screenWidth * 0.01,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      if (isEditing) {
                        updateUserData(); // Update data when editing is complete
                      }
                      toggleEditing(); // Toggle editing mode
                    },
                    child: isEditing ? Icon(Icons.check) : Icon(Icons.edit),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                ],
              ),
            ),
            // Save Password button
            if (isChangingPassword && !passwordChanged)
              Positioned(
                bottom: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Column(
                  children: [
                    if (passwordError.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          passwordError,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Custom__Button(
                      onPressed: () {
                        changeUserPassword();
                      },
                      buttonText: 'Save Password',
                    ),
                  ],
                ),
              ),
            // Data update message
            if (dataUpdateMsg.isNotEmpty)
              Positioned(
                bottom: screenWidth * 0.15,
                left: screenWidth * 0.1,
                child: Text(
                  dataUpdateMsg,
                  style: TextStyle(color: Colors.green),
                ),
              ),
            // Password change message
            if (passwordChangeMsg.isNotEmpty)
              Positioned(
                bottom: screenWidth * 0.1,
                left: screenWidth * 0.1,
                child: Text(
                  passwordChangeMsg,
                  style: TextStyle(
                    color: passwordChangeMsg.contains('successfully')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
