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
    // ignore: empty_catches
  } catch (e) {}
}

Future<Prospect> getUserInfo() async {
  late Prospect userInfo;
  User? user = FirebaseAuth.instance.currentUser;

  try {
    final isProfileExist = await isProfileUpdated();
    if (isProfileExist) {
      return getLoggedUserRoleData();
    }

    if (user != null) {
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
    try {
      DocumentSnapshot prospectSnapshot = await FirebaseFirestore.instance
          .collection('prospects')
          .doc(user!.uid)
          .get();
      userInfo = Prospect(
          uid: user.uid,
          email: user.email ?? '',
          memberId: '',
          userClub:
              prospectSnapshot.exists ? prospectSnapshot.get('userClub') : '',
          name: user.displayName ?? '',
          role: prospectSnapshot.exists ? 'Prospect' : '');
    } catch (e) {
      userInfo = Prospect(
          uid: user!.uid,
          email: user.email ?? '',
          memberId: '',
          userClub: '',
          name: user.displayName ?? '',
          role: '');
    }
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
  try {
    DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) => value.docs.first);

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
  } catch (e) {
    try {
      DocumentSnapshot prospectSnapshot = await FirebaseFirestore.instance
          .collection('prospects')
          .doc(uid)
          .get();

      if (prospectSnapshot.exists) {
        userInfo = {
          'uid': uid,
          'memberId': '',
          'userClub': prospectSnapshot.get('userClub') ?? '',
          'name': prospectSnapshot.get('name') ?? '',
          'role': 'Prospect',
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
    } catch (e) {
      userInfo = {
        'uid': uid,
        'memberId': '',
        'userClub': '',
        'name': '',
        'role': 'Prospect',
      };
    }
  }

  return userInfo;
}

Future<String> findAdminClub(String uid) async {
  try {
    final adminDoc =
        await FirebaseFirestore.instance.collection('admins').doc(uid).get();
    return adminDoc.get('club');
  } catch (e) {
    return '';
  }
}
