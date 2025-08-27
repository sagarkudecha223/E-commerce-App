import 'package:bloc_base_architecture/api/network/network_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../injector/injection.dart';
import '../../localization/app_localization.dart';
import '../../model/user_model.dart';
import '../user/user_service.dart';
import 'firebase_user_data_service.dart';

@singleton
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService;
  final FirebaseUserDataService _firebaseUserDataService;

  FirebaseAuthService(this._userService, this._firebaseUserDataService);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<bool> isNetworkConnected() async =>
      await getIt
          .get<NetworkInfoImpl>()
          .isConnected;

  Future<User?> signUpWithEmail(String email,
      String password,
      String userName,) async {
    if (await isNetworkConnected()) {
      try {
        final result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (result.user != null) {
          await _createUserProfileIfNotExists(result.user!, userName);
        }

        return result.user;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'weak-password':
            throw AuthException('Password must be at least 6 characters.');
          case 'email-already-in-use':
            throw AuthException('This email is already registered.');
          case 'invalid-email':
            throw AuthException('Please enter a valid email.');
          default:
            throw AuthException('Sign up failed: ${e.message}');
        }
      }
    } else {
      throw Exception(
        AppLocalization
            .currentLocalization()
            .noInternetConnection,
      );
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    if (await isNetworkConnected()) {
      try {
        final result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = result.user;
        if (user != null) {
          await _createUserProfileIfNotExists(user, '');
          await _userService.saveUser(
            UserModel(
              name: user.displayName ?? '',
              email: user.email ?? '',
              profilePhotoUrl: user.photoURL ?? '',
              uid: user.uid,
            ),
          );
          await _userService.setUserLoggedIn();
        }

        return result.user;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'invalid-credential':
          case 'wrong-password':
            throw AuthException('Invalid email or password.');
          case 'user-not-found':
            throw AuthException('No account found for that email.');
          case 'user-disabled':
            throw AuthException('This account has been disabled.');
          default:
            throw AuthException('Login failed: ${e.message}');
        }
      } catch (e) {
        throw AuthException('Unexpected error: $e');
      }
    } else {
      throw AuthException(
        AppLocalization
            .currentLocalization()
            .noInternetConnection,
      );
    }
  }

  Future<User?> signInWithGoogle() async {
    if (await isNetworkConnected()) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user != null) {
        await _createUserProfileIfNotExists(user, '');
        await _userService.saveUser(
          UserModel(
            name: user.displayName ?? '',
            email: user.email ?? '',
            profilePhotoUrl: user.photoURL ?? '',
            uid: user.uid,
          ),
        );
        await _userService.setUserLoggedIn();
      }

      return result.user;
    } else {
      throw AuthException(
        AppLocalization
            .currentLocalization()
            .noInternetConnection,
      );
    }
  }

  Future<void> _createUserProfileIfNotExists(User user,
      String? userName,) async {
    final userRef = await _firebaseUserDataService.userExists();

    if (!userRef) {
      await _firebaseUserDataService.saveUserProfile(
          user: user, userName: userName);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
