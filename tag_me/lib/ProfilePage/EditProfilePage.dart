// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';
import 'package:tag_me/utilities/clubServices.dart';
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

  // final TextEditingController _clubController = TextEditingController();

  late String _selectedRole = 'Prospect';
  late String _selectedDesignation;
  late String _selectedDistrict;
  late String _selectedClub;
  List<String> districts = [];
  List<String> clubs = [];
  List<String> designations = [];
  late Prospect prospect;

  @override
  void initState() {
    super.initState();
    _selectedDistrict = '';
    _selectedClub = '';
    _selectedDesignation = '';
    loadData();
  }

  Future<void> loadData() async {
    districts = await loadDistrictsFromCache();
    clubs = await loadClubsFromDistrict(districts[0]);
    designations = await loadDesignations();
    prospect = await getUserInfo();

    setState(() {
      _nameController.text = prospect.name;
      _selectedRole = prospect.role;
      _memberIdController.text = prospect.memberId;
      _selectedDesignation = prospect.designation;
      _selectedDistrict = prospect.district;
      _selectedClub = prospect.userClub;
      _selectedDistrict = prospect.district;
    });
  }

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
            PopupMenuButton<String>(
              child: ListTile(
                leading:
                    const Text('Leo District:', style: TextStyle(fontSize: 16)),
                title: Text(_selectedDistrict),
                trailing: const Icon(Icons.arrow_drop_down),
              ),
              itemBuilder: (BuildContext context) {
                return districts.map((district) {
                  return PopupMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList();
              },
              onSelected: (value) {
                setState(() {
                  _selectedDistrict = value;
                });
              },
            ),
            FutureBuilder(
              future: loadClubsFromDistrict(_selectedDistrict),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return Text('Error loading clubs: ${snapshot.error}');
                } else {
                  clubs = snapshot.data as List<String>;
                  if (clubs.isNotEmpty && !clubs.contains(_selectedClub)) {
                    _selectedClub = clubs[0];
                  }
                  return PopupMenuButton<String>(
                    child: ListTile(
                      leading:
                          const Text('Club:', style: TextStyle(fontSize: 16)),
                      title: Text(_selectedClub),
                      trailing: const Icon(Icons.arrow_drop_down),
                    ),
                    itemBuilder: (BuildContext context) {
                      return clubs.map((club) {
                        return PopupMenuItem<String>(
                          value: club,
                          child: Text(club),
                        );
                      }).toList();
                    },
                    onSelected: (value) {
                      setState(() {
                        _selectedClub = value;
                      });
                    },
                  );
                }
              },
            ),
            PopupMenuButton<String>(
              child: ListTile(
                leading: const Text('Member/Prospect:',
                    style: TextStyle(fontSize: 16)),
                title: Text(_selectedRole),
                trailing: const Icon(Icons.arrow_drop_down),
              ),
              itemBuilder: (BuildContext context) {
                return ["Prospect", "Member"].map((role) {
                  return PopupMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList();
              },
              onSelected: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            if (_selectedRole == 'Member') ...[
              TextFormField(
                controller: _memberIdController,
                decoration: const InputDecoration(labelText: 'Member ID'),
              ),
              const SizedBox(height: 16.0),
              PopupMenuButton<String>(
                child: ListTile(
                  leading: const Text('Designation:',
                      style: TextStyle(fontSize: 16)),
                  title: Text(_selectedDesignation),
                  trailing: const Icon(Icons.arrow_drop_down),
                ),
                itemBuilder: (BuildContext context) {
                  return designations.map((designation) {
                    return PopupMenuItem<String>(
                      value: designation,
                      child: Text(designation),
                    );
                  }).toList();
                },
                onSelected: (value) {
                  setState(() {
                    _selectedDesignation = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name cannot be empty'),
                    ),
                  );
                  return;
                } else {
                  updateProfile(
                          _nameController.text,
                          _selectedRole,
                          _memberIdController.text,
                          _selectedClub,
                          _selectedDesignation,
                          _selectedDistrict)
                      .then((value) => Navigator.pop(context))
                      .catchError((error) {
                    Navigator.pop(context);
                    // ignore: avoid_print
                    print(error);
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
