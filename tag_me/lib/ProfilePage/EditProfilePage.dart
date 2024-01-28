// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/utilities/userServices.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/EditProfilePage';

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _memberIdController = TextEditingController();

  String _selectedRole = 'prospect';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
              items: ['prospect', 'member'].map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            ),
            if (_selectedRole == 'member') ...[
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _memberIdController,
                decoration: const InputDecoration(labelText: 'Member ID'),
              ),
            ],
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await updateProfile(_nameController.text, _selectedRole,
                    _memberIdController.text);
                
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
