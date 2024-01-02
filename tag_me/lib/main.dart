// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tag_me/SigninPage/SigninPage.dart';
import 'package:tag_me/WelcomePage/WelcomePage.dart';
import 'package:tag_me/SignupPage/SignupPage.dart';
import 'package:tag_me/HomePage/HomePage.dart';
import 'package:tag_me/constants/constants.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomePage.routeName,
      routes: {
        WelcomePage.routeName: (context) => const WelcomePage(),
        HomePage.routeName: (context) => const HomePage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        SignInPage.routeName: (context) => const SignInPage(), // Fix the class name here
        MyHomePage.routeName: (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const String routeName = '/MyHomePage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // Define the pages and their corresponding icons
  final List<Map<String, dynamic>> _pages = [
    {'title': 'Home', 'icon': Icons.home, 'page': const HomePage()},
    {'title': 'Profile', 'icon': Icons.person, 'page': const ProfilePage()},
    {'title': 'Settings', 'icon': Icons.settings, 'page': const SettingsPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentIndex]['title'], style: kappBarTextStyle),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ktextColorWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _pages[_currentIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kNavbarBackgroundColor,
        selectedItemColor: kNavbarSelectedIconColor,
        unselectedItemColor: kNavbarIconColor,
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
        items: _pages
            .map(
              (page) => BottomNavigationBarItem(
                icon: Icon(page['icon']),
                label: page['title'],
              ),
            )
            .toList(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Welcome to Profile'),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Welcome to Settings'),
    );
  }
}
