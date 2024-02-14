// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';

Future<void> updateProfile(String name, String selectedRole, String memberId,
    String userClub, String designation, String district) async {
  try {
    AppUser loggedInUser = await getLoggedInUserInfo();

    if (loggedInUser.uid.isNotEmpty) {
      if (selectedRole == 'Member') {
        await updateMemberCollection(
            loggedInUser.uid, name, memberId, userClub, designation, district);
        print("member path");
      } else {
        await updateProspectCollection(
            loggedInUser.uid, name, userClub, district);
        print("prospect path");
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
        designation: designation,
        district: district,
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
          role: memberSnapshot.exists ? 'Member' : 'Prospect',
          designation:
              memberSnapshot.exists ? memberSnapshot.get('designation') : '',
          district:
              memberSnapshot.exists ? memberSnapshot.get('district') : '');

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
          role: prospectSnapshot.exists ? 'Prospect' : '',
          designation: '',
          district:
              prospectSnapshot.exists ? prospectSnapshot.get('district') : '');
    } catch (e) {
      userInfo = Prospect(
          uid: user!.uid,
          email: user.email ?? '',
          memberId: '',
          userClub: '',
          name: user.displayName ?? '',
          role: '',
          designation: '',
          district: '');
    }
  }

  return userInfo;
}

Future<void> updateMemberCollection(String uid, String name, String memberId,
    String userClub, String designation, String district) async {
  await FirebaseFirestore.instance.collection('members').doc(memberId).set({
    'uid': uid,
    'name': name,
    'memberId': memberId,
    'userClub': userClub,
    'designation': designation,
    'district': district
  });
}

Future<void> updateProspectCollection(
    String uid, String name, String userClub, String district) async {
  final membersCollection = FirebaseFirestore.instance.collection('members');
  final prospectsCollection =
      FirebaseFirestore.instance.collection('prospects');

  final memberQuery =
      await membersCollection.where('uid', isEqualTo: uid).get();

  if (memberQuery.docs.isNotEmpty) {
    await membersCollection.doc(memberQuery.docs.first.id).delete();
  }

  await prospectsCollection.doc(uid).set(
      {'name': name, 'uid': uid, 'userClub': userClub, 'district': district});
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
        'designation': memberSnapshot.get('designation') ?? '',
        'district': memberSnapshot.get('district') ?? '',
      };
    } else {
      userInfo = {
        'uid': uid,
        'memberId': '',
        'userClub': '',
        'name': '',
        'role': 'Prospect',
        'designation': '',
        'district': '',
      };
    }
  } catch (e) {
    try {
      print("on fetching prospect data $uid");
      DocumentSnapshot prospectSnapshot = await FirebaseFirestore.instance
          .collection('prospects')
          .doc(uid)
          .get();

      if (prospectSnapshot.exists) {
        print("on fetching prospect data success $uid");
        userInfo = {
          'uid': uid,
          'memberId': '',
          'userClub': prospectSnapshot.get('userClub') ?? '',
          'name': prospectSnapshot.get('name') ?? '',
          'role': 'Prospect',
          'designation':'',
          'district': prospectSnapshot.get('district') ?? '',
        };
      } else {
        print("on fetching prospect data fail $uid");

        userInfo = {
          'uid': uid,
          'memberId': '',
          'userClub': '',
          'name': '',
          'role': 'Prospect',
          'designation': '',
          'district': '',
        };
      }
    } catch (e) {
      print("on fetching prospect data fail $uid");
      userInfo = {
        'uid': uid,
        'memberId': '',
        'userClub': '',
        'name': '',
        'role': 'Prospect',
        'designation': '',
        'district': '',
      };
    }
  }
  print("on fetching data $userInfo");
  return userInfo;
}

Future<String> findAdminDistrict(String uid) async {
  try {
    final adminDoc =
        await FirebaseFirestore.instance.collection('admins').doc(uid).get();
    return adminDoc.get('district');
  } catch (e) {
    return '';
  }
}
