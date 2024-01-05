import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCertificateData({
    required String certificateName,
    required String assigneeName,
    required String institutionName,
    required String certificatePurpose,
    required DateTime? passOutDate,
    required String signature,
    required String assigneeEmail,
    required String uniqueHashCode, // Updated
  }) async {
    try {
      await _firestore.collection('certificates').add({
        'certificateName': certificateName,
        'assigneeName': assigneeName,
        'institutionName': institutionName,
        'certificatePurpose': certificatePurpose,
        'passOutDate': passOutDate,
        'signature': signature,
        'assigneeEmail': assigneeEmail,
        'uniqueHashCode': uniqueHashCode,
      });

      // Optionally, you may want to handle success or provide feedback to the user.
      print('Certificate data saved successfully');
    } catch (error) {
      // Handle errors or provide feedback to the user.
      print('Error saving certificate data: $error');
    }
  }
}
