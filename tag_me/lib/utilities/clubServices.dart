// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> loadClubsFromDistrict(String districtId) async {
  try {
    CollectionReference districtsCollection =
        FirebaseFirestore.instance.collection('clubs');

    DocumentSnapshot districtSnapshot =
        await districtsCollection.doc(districtId).get();

    if (districtSnapshot.exists) {
      List<String> clubs =
          (districtSnapshot.data() as Map<String, dynamic>)['clubs']
              .cast<String>();

      print(clubs); // Debugging: print the clubs list
      return clubs;
    } else {
      return [];
    }
  } catch (e) {
    print("Error retrieving clubs in district: $e");
    return [];
  }
}

// Example usage:
Future<List<String>> findDistricts() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('clubs').get();

    List<String> districtList = querySnapshot.docs.map((e) => e.id).toList();

    return districtList;
  } catch (e) {
    print("Error fetching district documents: $e");
    return [];
  }
}

Future<List<String>> loadDesignations() async {
  try {
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection('designations')
        .doc("all_designations")
        .get();
    if (data.exists) {
      List<String> designations =
          (data.data() as Map<String, dynamic>)['designations'].cast<String>();
      return designations;
    } else {
      return [];
    }
  } catch (e) {
    print("Error fetching designation documents: $e");
    return [];
  }
}
