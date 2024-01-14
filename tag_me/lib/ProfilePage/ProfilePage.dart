// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/ProfilePage/History.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
          const ListTile(
            title: Text('John Doe', style: TextStyle(fontSize: 24)),
          ),
          ListTile(
            title: Text('Software Developer',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ),
          _buildProfileItem(context, 'Email', 'john.doe@example.com'),
          _buildProfileItem(context, 'Phone', '+123 456 7890'),
          _buildProfileItem(context, 'Location', 'City, Country'),
          _buildProfileItem(context, 'Events-Participated', '3'),
          _buildProfileItem(context, 'Events-Created', '3'),
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
                onPressed: () {
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
                onPressed: () {
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
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
