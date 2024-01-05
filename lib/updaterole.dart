import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Reference to the users collection
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

  // Fetch all existing documents
  QuerySnapshot<Map<String, dynamic>> snapshot = await users.get();

  // Update each document with the new field
  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
    await users.doc(doc.id).update({
      'role': 'verifier', // Replace with your new field and default value
    });
    print('Updated document: ${doc.id}');
  }

  print('Update complete');
}
