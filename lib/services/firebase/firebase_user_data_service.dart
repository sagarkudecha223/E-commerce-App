import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseUserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  /// Save or update user profile in Firestore
  Future<void> saveUserProfile({required User user,String? userName}) async {
    await _firestore.collection('users').doc(_uid).set({
      "uid": user.uid,
      "name": user.displayName ?? userName,
      "email": user.email ?? "",
      "photoUrl": user.photoURL ?? "",
      "createdAt": DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<bool> userExists() async {
    final doc = await _firestore.collection('users').doc(_uid).get();
    return doc.exists;
  }

  /// Get user profile as stream
  Stream<Map<String, dynamic>?> getUserProfileStream() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .snapshots()
        .map((doc) => doc.data());
  }
}
