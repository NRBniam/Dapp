import 'package:flutter/material.dart';

class CertificateDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> certificateData;

  CertificateDetailsScreen({required this.certificateData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Certificate Name: ${certificateData['certificateName']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Assignee: ${certificateData['assigneeName']}'),
            SizedBox(height: 10),
            Text('Institution: ${certificateData['institutionName']}'),
            SizedBox(height: 10),
            Text('Purpose: ${certificateData['certificatePurpose']}'),
            SizedBox(height: 10),
            Text(
              'Pass Out Date: ${certificateData['passOutDate'] != null ? '${certificateData['passOutDate'].toDate().month}/${certificateData['passOutDate'].toDate().year}' : 'Not available'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('Signature: ${certificateData['signature']}'),
            SizedBox(height: 20),
            Text('Assignee Email: ${certificateData['assigneeEmail']}'),
            SizedBox(height: 20),
            Text('Unique Hash Code: ${certificateData['uniqueHashCode']}'),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateDetailsScreen extends StatelessWidget {
  final String certificateId;

  CertificateDetailsScreen({required this.certificateId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: fetchCertificateDataFromFirebase(certificateId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Certificate Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    // Close button logic here
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Certificate Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    // Close button logic here
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Certificate Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    // Close button logic here
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            body: Center(
              child: Text('Certificate data not found'),
            ),
          );
        } else {
          Map<String, dynamic> certificateData =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            appBar: AppBar(
              title: Text('Certificate Details'),
              actions: [
                IconButton(
                  onPressed: () {
                    // Close button logic here
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to the FinalCertificateScreen with the fetched certificate details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinalCertificateScreen(
                          certificateName: certificateData['certificateName'],
                          assigneeName: certificateData['assigneeName'],
                          institutionName: certificateData['institutionName'],
                          certificatePurpose:
                              certificateData['certificatePurpose'],
                          passOutDate: certificateData['passOutDate'],
                          signature: certificateData['signature'],
                          uniqueHashCode: certificateData['uniqueHashCode'],
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Certificate Name: ${certificateData['certificateName']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Assignee: ${certificateData['assigneeName']}'),
                  SizedBox(height: 10),
                  Text('Institution: ${certificateData['institutionName']}'),
                  SizedBox(height: 10),
                  Text('Purpose: ${certificateData['certificatePurpose']}'),
                  SizedBox(height: 10),
                  Text(
                    'Pass Out Date: ${certificateData['passOutDate'] != null ? '${certificateData['passOutDate'].toDate().month}/${certificateData['passOutDate'].toDate().year}' : 'Not available'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text('Signature: ${certificateData['signature']}'),
                  SizedBox(height: 20),
                  Text('Assignee Email: ${certificateData['assigneeEmail']}'),
                  SizedBox(height: 20),
                  Text(
                      'Unique Hash Code: ${certificateData['uniqueHashCode']}'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<DocumentSnapshot> fetchCertificateDataFromFirebase(
      String certificateId) async {
    // Fetch the certificate data from the "certificates" collection in Firestore
    DocumentSnapshot certificateSnapshot = await FirebaseFirestore.instance
        .collection('certificates')
        .doc(certificateId)
        .get();

    return certificateSnapshot;
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
*/