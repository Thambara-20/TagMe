// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tag_me/screens/AboutPage/AboutPage.dart';
import 'package:tag_me/screens/ProfilePage/EditProfilePage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/authService.dart';
import 'package:tag_me/utilities/userServices.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/locationService.dart';
import '../../components/Comfirmation/comfirmationDialog.dart';

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
                  kProfilePageBackgroundColorI,
                  kProfilePageBackgroundColorII,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon:
                      const Icon(Icons.close, color: kProfileCloseButtonColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: kAvatarBackgroundColor,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: kProfilePageBackgroundColorII,
                  ),
                ),
              ),
            ]),
          ),
          ListTile(
            title: Text(prospect.name, style: const TextStyle(fontSize: 20)),
          ),
          _buildProfileItem(context, 'Prospect/Member', prospect.role),
          _buildProfileItem(context, 'Email', prospect.email),
          _buildProfileItem(context, 'Location', _location),
          _buildProfileItem(context, 'Leo District', prospect.district),
          _buildProfileItem(context, 'Leo Club', prospect.userClub),
          _buildProfileItem(context, 'Designation', prospect.designation),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info,
                color: kEditProfileButtonBackgroundColor),
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
                  backgroundColor: kEditProfileButtonBackgroundColor,
                  elevation: 5,
                  shadowColor: kProfilePageBackgroundColorII,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style:
                      TextStyle(fontSize: 16, color: kProfileNormalTextColor),
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
                  shadowColor: kProfilePageBackgroundColorII,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
                child: const Text(
                  'Logout',
                  style:
                      TextStyle(fontSize: 16, color: kProfileNormalTextColor),
                ),
              ),
              const SizedBox(height: 16),
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
              baseColor: const Color.fromARGB(47, 144, 144, 144),
              highlightColor: const Color.fromARGB(58, 245, 245, 245),
              child: Container(
                color: const Color.fromARGB(204, 0, 36, 99),
                height: 25.0,
                margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              ),
            ),
    );
  }
}
