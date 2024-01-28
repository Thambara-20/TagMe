import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final bool isAdmin;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.isAdmin,
  });

  factory AppUser.fromFirebaseUser(User firebaseUser, bool isAdmin) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      isAdmin: isAdmin,
    );
  }
}