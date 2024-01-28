import 'package:flutter/material.dart';
import 'package:tag_me/ProfilePage/EditProfilePage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/ProfilePage/History.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/authService.dart';
import 'package:tag_me/utilities/userServices.dart';

import '../utilities/Location.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/ProfilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Prospect prospect =
      Prospect(memberId: "", name: "", role: "", email: "", uid: "");
  String _location = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

Future<void> _loadUserInfo() async {
  Prospect loadedprospect = await getUserInfo();
  String loadedLocation = await getArea();

  // Check if the widget is still mounted before calling setState
  if (mounted) {
    setState(() {
      prospect = loadedprospect;
      _location = loadedLocation;
    });
  }
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
            title: Text(prospect.name, style: const TextStyle(fontSize: 20)),
          ),
          ListTile(
            title: Text("Role: ${prospect.role}", //member/prospect
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
          _buildProfileItem(context, 'Email', prospect.email),
          _buildProfileItem(context, 'Location', _location),
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
