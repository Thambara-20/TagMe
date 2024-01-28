import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';

Future<void> updateProfile(
    String name, String selectedRole, String memberId) async {
  try {
    AppUser loggedInUser = await getLoggedInUserInfo();

    if (loggedInUser.uid.isNotEmpty) {
      if (selectedRole == 'member') {
        await updateMemberCollection(loggedInUser.uid, name, memberId);
      } else {
        await updateProspectCollection(loggedInUser.uid, name);
      }

      User? fireUser = FirebaseAuth.instance.currentUser;

      if (fireUser != null) {
        await fireUser.updateDisplayName(name);
      }

      Prospect prospect = Prospect(
        uid: loggedInUser.uid,
        email: loggedInUser.email,
        memberId: memberId,
        name: name,
        role: selectedRole,
      );

      await updateUserRole(prospect);
    }
  } catch (e) {
    print('Error updating profile: $e');
  }
}

Future<Prospect> getUserInfo() async {
  late Prospect userInfo;

  try {
    final isProfileExist = await isProfileUpdated();
    User? user = FirebaseAuth.instance.currentUser;
    if (isProfileExist) {
      return getLoggedUserRoleData();
    }

    if (user != null) {
      DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(user.uid)
          .get();

      userInfo = Prospect(
          uid: user.uid,
          email: user.email ?? '',
          memberId: memberSnapshot.exists ? memberSnapshot.id : '',
          name: user.displayName ?? '',
          role: memberSnapshot.exists ? 'Member' : 'Prospect');
    }
  } catch (e) {
    print('Error loading user info from Firebase: $e');
    userInfo = Prospect(
      uid: '',
      email: '',
      memberId: '',
      name: '',
      role: '',
    );
  }

  return userInfo;
}

Future<void> updateMemberCollection(
    String uid, String name, String memberId) async {
  await FirebaseFirestore.instance.collection('members').doc(memberId).set({
    'uid': uid,
    'name': name,
    'memberId': memberId,
  });
}

Future<void> updateProspectCollection(String uid, String name) async {
  await FirebaseFirestore.instance
      .collection('prospects')
      .doc(uid)
      .set({'name': name, 'uid': uid});
}

Future<Map<String, dynamic>> getParticipantsInfo(String uid) async {
  Map<String, dynamic> userInfo;

  DocumentSnapshot memberSnapshot =
      await FirebaseFirestore.instance.collection('members').doc(uid).get();

  if (memberSnapshot.exists) {
    userInfo = {
      'uid': uid,
      'memberId': memberSnapshot.id,
      'name': memberSnapshot.get('name') ?? '',
      'role': 'Member',
    };
  } else {
    userInfo = {
      'uid': uid,
      'memberId': '',
      'name': '',
      'role': 'Prospect',
    };
  }

  return userInfo;
}
