import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final bool isAdmin;

  AppUser({
    required this.uid,
    required this.email,
    required this.isAdmin,
  });
}

class Prospect extends AppUser {
  final String memberId;
  final String designation;
  final String name;
  final String role;
  final String district;
  final String userClub;

  Prospect({
    required this.memberId,
    required this.designation,
    required this.name,
    required this.district,
    required this.role,
    required this.userClub,
    required String email,
    required String uid,
  }) : super(
          uid: uid,
          email: email,
          isAdmin: false,
        );
}

abstract class UserFactory {
  AppUser createUserFromFirebase(User firebaseUser, bool isAdmin);
  Prospect createProspectFromFirebase(Prospect user, bool isAdmin);
}

class AppUserFactory implements UserFactory {
  @override
  AppUser createUserFromFirebase(User firebaseUser, bool isAdmin) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      isAdmin: isAdmin,
    );
  }

  @override
  Prospect createProspectFromFirebase(Prospect user, bool isAdmin) {
    throw Exception("AppUserFactory cannot create prospects");
  }
}
