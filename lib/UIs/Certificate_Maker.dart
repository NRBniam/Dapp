/*import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:certy_chain_nrb/UIs/Certificates/assigning_certs.dart';
import 'package:certy_chain_nrb/UIs/Certificates_details/final_certificatescreen';
import 'package:certy_chain_nrb/custom_widgets/custom_buttons.dart';
import 'package:certy_chain_nrb/custom_widgets/custom_text_form_field.dart';
import 'package:crypto/crypto.dart';
import 'package:certy_chain_nrb/Backend/firestoreservice.dart';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';


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



*/
