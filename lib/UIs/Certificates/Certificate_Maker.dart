import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:certy_chain_nrb/Backend/abi.dart';

import 'package:web3dart/web3dart.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';
import 'package:crypto/crypto.dart';
import 'package:certy_chain_nrb/Backend/firestoreservice.dart';
import 'package:web3dart/web3dart.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';

/*Future<void> sendEmail(String recipient, String subject, String body) async {
  final smtpServer = gmail('your@gmail.com', 'your_password');

  // Create the email message
  final message = Message()
    ..from = Address('your@gmail.com', 'Your Name')
    ..recipients.add(recipient)
    ..subject = subject
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } catch (e) {
    print('Error occurred while sending email: $e');
  }
}*/

class CertificateMakerScreen extends StatefulWidget {
  @override
  _CertificateMakerScreenState createState() => _CertificateMakerScreenState();
}

class _CertificateMakerScreenState extends State<CertificateMakerScreen> {
  String certificateName = '';
  String assigneeName = '';
  String institutionName = '';
  String certificatePurpose = '';
  DateTime? passOutDate;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Certificate Generator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0XFF2E3F42),
        toolbarHeight: 100,
      ),
      body: Container(
        color: Color(0XFF2E3F42),
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(screenHeight * 0.025),
                  height: 600,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Certificate Generator',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: Color(0XFF2E3F42),
                              fontSize: 35),
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              certificateName = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Certificate Name',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              assigneeName = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Assignee Name',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              institutionName = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Educational Institution',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              certificatePurpose = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Certificate Purpose',
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          title: Text(
                            'Pass Out Date:',
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: passOutDate != null
                              ? Text(
                                  '${passOutDate!.month}/${passOutDate!.year}',
                                  style: TextStyle(fontSize: 16),
                                )
                              : Text(
                                  'Not selected',
                                  style: TextStyle(fontSize: 16),
                                ),
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (selectedDate != null &&
                                selectedDate != passOutDate) {
                              setState(() {
                                passOutDate = selectedDate;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Custom__Button(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CertificateAssignmentScreen(
                                    certificateName: certificateName,
                                    assigneeName: assigneeName,
                                    institutionName: institutionName,
                                    certificatePurpose: certificatePurpose,
                                    passOutDate: passOutDate,
                                  ),
                                ),
                              );
                            },
                            buttonText: 'Next',
                          ),
                        ),
                      ],
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
}

class CertificateAssignmentScreen extends StatefulWidget {
  final String certificateName;
  final String assigneeName;
  final String institutionName;
  final String certificatePurpose;
  final DateTime? passOutDate;

  CertificateAssignmentScreen({
    required this.certificateName,
    required this.assigneeName,
    required this.institutionName,
    required this.certificatePurpose,
    required this.passOutDate,
  });

  @override
  _CertificateAssignmentScreenState createState() =>
      _CertificateAssignmentScreenState();
}

class _CertificateAssignmentScreenState
    extends State<CertificateAssignmentScreen> {
  String signature = '';
  String assigneeEmail = '';
  String generateUniqueHashCode() {
    final String data = DateTime.now().toString() +
        widget.certificateName +
        widget.assigneeName;
    final Digest digest = sha256.convert(utf8.encode(data));
    return digest.toString().substring(0, 32); // Take the first 32 characters
  }

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Certificate Generator - Assign',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0XFF2E3F42),
        toolbarHeight: 100,
      ),
      body: Container(
        color: Color(0XFF2E3F42),
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(screenHeight * 0.025),
                  height: 600,
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
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Certificate Name: ${widget.certificateName}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 10),
                        Text('Assignee: ${widget.assigneeName}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        SizedBox(height: 10),
                        Text('Institution: ${widget.institutionName}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        SizedBox(height: 10),
                        Text('Purpose: ${widget.certificatePurpose}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        SizedBox(height: 10),
                        Text(
                          'Pass Out Date: ${widget.passOutDate != null ? '${widget.passOutDate!.month}/${widget.passOutDate!.year}' : 'Not selected'}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 20),
                        CustomTextFormField(
                          onChanged: (value) {
                            setState(() {
                              assigneeEmail = value;
                            });
                          },
                          decoration: InputDecoration(),
                          hintText: 'Assignee Email',
                        ),
                        // Signature Input (Either Image or Text)

                        TextField(
                          onChanged: (value) {
                            setState(() {
                              signature = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Signature',
                          ),
                        ),
                        SizedBox(height: 20),
                        Custom__Button(
                          onPressed: () {
                            setState(() {
                              String uniqueHashCode = generateUniqueHashCode();
                              /*assigneeEmail.isNotEmpty
                                  ? sendEmail(assigneeEmail, uniqueHashCode)
                                  : print('Assignee email is empty');*/

                              // Display a dialog with the unique hash code
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Unique Hash Code',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline)),
                                    content: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(uniqueHashCode,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () {
                                            // Copy to clipboard logic here
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: uniqueHashCode,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Hash copied to clipboard'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Copy to Clipboard',
                                            style: TextStyle(
                                              color: Color(0XFF2E3F42),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Custom__Button(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                          // Navigate to the next screen here if needed
                                          _firestoreService.saveCertificateData(
                                            certificateName:
                                                widget.certificateName,
                                            assigneeName: widget.assigneeName,
                                            institutionName:
                                                widget.institutionName,
                                            certificatePurpose:
                                                widget.certificatePurpose,
                                            passOutDate: widget.passOutDate,
                                            signature: signature,
                                            assigneeEmail: assigneeEmail,
                                            uniqueHashCode: uniqueHashCode,
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FinalCertificateScreen(
                                                certificateName:
                                                    widget.certificateName,
                                                assigneeName:
                                                    widget.assigneeName,
                                                institutionName:
                                                    widget.institutionName,
                                                certificatePurpose:
                                                    widget.certificatePurpose,
                                                passOutDate: widget.passOutDate,
                                                signature: signature,
                                                uniqueHashCode: uniqueHashCode,
                                              ),
                                            ),
                                          );
                                        },
                                        buttonText: 'OK',
                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                          },
                          buttonText: 'Generate Certificate',
                        ),
                      ],
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
}

class FinalCertificateScreen extends StatelessWidget {
  final String certificateName;
  final String assigneeName;
  final String uniqueHashCode;
  final String institutionName;
  final String certificatePurpose;
  final DateTime? passOutDate;
  final String signature;

  FinalCertificateScreen({
    required this.certificateName,
    required this.assigneeName,
    required this.uniqueHashCode,
    required this.institutionName,
    required this.certificatePurpose,
    required this.passOutDate,
    required this.signature,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Final Certificate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0XFF2E3F42),
        toolbarHeight: 80,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/certficateoutlines.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Certificate of Achievement',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'This is to certify that',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$assigneeName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'has been awarded the',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$certificateName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'by  ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '$institutionName',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'for the ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'completion of ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      ' $certificatePurpose.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Pass Out Date: ${passOutDate != null ? '${passOutDate!.month}/${passOutDate!.year}' : 'Not selected'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                // Display Signature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$signature',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
                      height: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
