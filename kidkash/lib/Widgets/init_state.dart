import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { parent, kid }

Future<User?> signInAndSetRole(UserRole role) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final userCredential = await auth.signInAnonymously();
  final user = userCredential.user;
  if (user != null) {
    await firestore.collection('users').doc(user.uid).set({
      'role': role.name, // "parent" or "kid"
      'sessionID': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  return user;
}

// This function is waiting on a user value from a front end choice.
//User? user = FirebaseAuth.instance.currentUser; 
//if (user == null) {
//  user = await signInAndSetRole(UserRole.parent); // or prompt for role
//}

