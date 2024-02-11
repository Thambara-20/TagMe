// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  factory FirebaseAuthService() {
    return _instance;
  }

  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled the sign-in process
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = authResult.user;

      if (firebaseUser != null) {
        final bool isAdmin = await isUserAdmin(firebaseUser.uid);
        final AppUser user =
            AppUserFactory().createUserFromFirebase(firebaseUser, isAdmin);
        return user;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isUserAdmin(String uid) async {
    try {
      final adminDoc =
          await FirebaseFirestore.instance.collection('admins').doc(uid).get();
      return adminDoc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = authResult.user;
      if (user != null && user.emailVerified) {
        final User? firebaseUser = authResult.user;

        if (firebaseUser != null) {
          final bool isAdmin = await isUserAdmin(firebaseUser.uid);
          final AppUser user =
              AppUserFactory().createUserFromFirebase(firebaseUser, isAdmin);
          return user;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = authResult.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await removeLoggedInUser();
      // ignore: empty_catches
    } catch (e) {}
  }
}
