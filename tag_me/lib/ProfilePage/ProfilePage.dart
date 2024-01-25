// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tag_me/ProfilePage/EditProfilePage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/ProfilePage/History.dart';
import 'package:tag_me/utilities/authService.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/ProfilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '---'; // Updated dynamically from Firebase
  String _userRole = '---'; // Updated dynamically from Firestore
  String _userEmail = '---'; // Updated dynamically from Firebase
  String _userLocation = '---'; // Updated dynamically from Geolocator

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userName = user.displayName ?? '';
        _userEmail = user.email ?? '';

        DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance
            .collection('members')
            .doc(user.uid)
            .get();

        if (memberSnapshot.exists) {
          _userRole = 'Member';
        } else {
          _userRole = 'Prospect';
        }
        try {
          List<Placemark> placemarks = [];
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          Placemark place = placemarks[0];
          _userLocation = '${place.locality}, ${place.country}';
        } catch (e) {
          print(e);
        }
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kProfilePageBackgroundColor,
                  Color.fromARGB(255, 0, 0, 0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: kProfilePageBackgroundColor,
                  ),
                ),
              ),
            ]),
          ),
          ListTile(
            title: Text(_userName, style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            title: Text("Role: $_userRole", //member/prospect
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
          _buildProfileItem(context, 'Email', _userEmail),
          _buildProfileItem(context, 'Location', _userLocation),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.history,
                color: Color.fromARGB(255, 149, 149, 149)),
            title: const Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, EditProfilePage.routeName);
                  // Add functionality for editing profile
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 40),
                  backgroundColor: kProfileEditButtonColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  FirebaseAuthService authService = FirebaseAuthService();
                  await authService.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/WelcomePage');

                  // Add functionality for logout
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 40),
                  backgroundColor: kLogoutButtonColor,
                  elevation: 5,
                  shadowColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String label, String value) {
    return ListTile(
      title: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
