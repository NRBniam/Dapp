/*import 'dart:convert';
import 'package:certy_chain_nrb/Backend/firestoreservice.dart';
import 'package:certy_chain_nrb/UIs/Certificate_Maker.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';

import 'final_certificatescreen';


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
}*/