// ignore_for_file: library_private_types_in_public_api

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tag_me/EventsPage/EventsPage.dart';
import 'package:tag_me/SigninPage/SigninPage.dart';
import 'package:tag_me/WelcomePage/WelcomePage.dart';
import 'package:tag_me/SignupPage/SignupPage.dart';
import 'package:tag_me/HomePage/HomePage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/Map/Map.dart';

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
        EventsPage.routeName: (context) => const EventsPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        SignInPage.routeName: (context) => const SignInPage(),
        MainPage.routeName: (context) => const MainPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const String routeName = '/MainPage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {'title': 'Home', 'icon': Icons.home, 'page': const HomePage()},
    {'title': 'Events', 'icon': Icons.event, 'page': const EventsPage()},
    {'title': 'Profile', 'icon': Icons.person, 'page': const ProfilePage()},
    {'title': 'Settings', 'icon': Icons.settings, 'page': const SettingsPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentIndex]['title'], style: kappBarTextStyle),
        backgroundColor: khomePageBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ktextColorWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _pages[_currentIndex]['page'],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: khomePageBackgroundColor,
        color: kNavbarBackgroundColor,
        buttonBackgroundColor: kNavbarButtonBackgroundColor,
        animationDuration: const Duration(milliseconds: 300),
        height: 50,
        items: _pages
            .map(
              (page) => Icon(page['icon'], size: 30, color: kNavbarButtonColor),
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
    return const MapWidget();
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
