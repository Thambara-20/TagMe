// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tag_me/AboutPage/AboutPage.dart';
import 'package:tag_me/ProfilePage/EditProfilePage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/authService.dart';
import 'package:tag_me/utilities/userServices.dart';
import 'package:shimmer/shimmer.dart';

import '../utilities/locationService.dart';
import '../utilities/comfirmationDialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/ProfilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Prospect prospect = Prospect(
      memberId: "",
      name: "",
      role: "",
      email: "",
      uid: "",
      userClub: "",
      district: "",
      designation: "");
  String _location = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    Prospect loadedprospect = await getUserInfo();
    String loadedLocation = await getArea();

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
            title: Text("Prospect/Member: ${prospect.role}", //member/prospect
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
          _buildProfileItem(context, 'Email', prospect.email),
          _buildProfileItem(context, 'Location', _location),
          _buildProfileItem(context, 'Leo District', prospect.district),
          _buildProfileItem(context, 'Club', prospect.userClub),
          _buildProfileItem(context, 'Designation', prospect.designation),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info,
                color: Color.fromARGB(255, 149, 149, 149)),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        onConfirm: () async {
                          FirebaseAuthService authService =
                              FirebaseAuthService();
                          try {
                            await authService.signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, '/WelcomePage');
                          } catch (e) {
                            Logger().e(e);
                          }
                        },
                        confirmationMessage:
                            'Are you sure you want to logout ?',
                      );
                    },
                  );
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
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String label, String value) {
    return ListTile(
      title: value != '' || label == 'Designation'
          ? Text(
              '$label: $value',
              style: const TextStyle(fontSize: 14),
            )
          : Shimmer.fromColors(
              baseColor: const Color.fromARGB(91, 0, 15, 55),
              highlightColor: const Color.fromARGB(64, 245, 245, 245),
              child: Container(
                color: const Color.fromARGB(255, 0, 0, 0),
                width: double.infinity,
                height: 20.0,
                margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              ),
            ),
    );
  }
}
