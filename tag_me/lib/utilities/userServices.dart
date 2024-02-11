// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';

Future<void> updateProfile(
    String name, String selectedRole, String memberId, String userClub) async {
  try {
    AppUser loggedInUser = await getLoggedInUserInfo();

    if (loggedInUser.uid.isNotEmpty) {
      if (selectedRole == 'member') {
        await updateMemberCollection(
            loggedInUser.uid, name, memberId, userClub);
      } else {
        await updateProspectCollection(loggedInUser.uid, name, userClub);
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
        userClub: userClub,
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
    if (isProfileExist) {
      return getLoggedUserRoleData();
    }

    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      print(isProfileExist);
      // document where doc contains user.uid

      DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) => value.docs.first);
      userInfo = Prospect(
          uid: user.uid,
          email: user.email ?? '',
          memberId: memberSnapshot.exists ? memberSnapshot.id : '',
          userClub: memberSnapshot.exists ? memberSnapshot.get('userClub') : '',
          name: user.displayName ?? '',
          role: memberSnapshot.exists ? 'Member' : 'Prospect');
      updateUserRole(userInfo);
    }
  } catch (e) {
    print('Error loading user info from Firebase: $e');
    userInfo = Prospect(
      uid: '',
      email: '',
      memberId: '',
      userClub: '',
      name: '',
      role: '',
    );
  }

  return userInfo;
}

Future<void> updateMemberCollection(
    String uid, String name, String memberId, String userClub) async {
  await FirebaseFirestore.instance.collection('members').doc(memberId).set(
      {'uid': uid, 'name': name, 'memberId': memberId, 'userClub': userClub});
}

Future<void> updateProspectCollection(
    String uid, String name, String userClub) async {
  await FirebaseFirestore.instance
      .collection('prospects')
      .doc(uid)
      .set({'name': name, 'uid': uid, 'userClub': userClub});
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
      'userClub': memberSnapshot.get('userClub') ?? '',
      'role': 'Member',
    };
  } else {
    userInfo = {
      'uid': uid,
      'memberId': '',
      'userClub': '',
      'name': '',
      'role': 'Prospect',
    };
  }

  return userInfo;
}
