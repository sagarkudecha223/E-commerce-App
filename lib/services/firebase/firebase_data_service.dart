import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseDataService {
  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // Save or Update User Profile
  Future<void> saveUserProfile({
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    await _db.child('users/$_uid/profile').set({
      'name': name,
      'email': email,
      'photoUrl': photoUrl ?? '',
    });
  }

  // Add Favorite Item
  Future<void> addFavorite(String productId) async {
    await _db.child('users/$_uid/favorites/$productId').set(true);
  }

  // Remove Favorite Item
  Future<void> removeFavorite(String productId) async {
    await _db.child('users/$_uid/favorites/$productId').remove();
  }

  // Stream of Favorites
  Stream<DatabaseEvent> getFavoritesStream() {
    return _db.child('users/$_uid/favorites').onValue;
  }

  // Get User Profile Stream
  Stream<DatabaseEvent> getUserProfileStream() {
    return _db.child('users/$_uid/profile').onValue;
  }
}
