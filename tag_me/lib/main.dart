// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_me/AboutPage/AboutPage.dart';
import 'package:tag_me/EventsPage/EventsPage.dart';
import 'package:tag_me/ProfilePage/EditProfilePage.dart';
import 'package:tag_me/ProfilePage/History.dart';
import 'package:tag_me/ProfilePage/ProfilePage.dart';
import 'package:tag_me/SigninPage/SigninPage.dart';
import 'package:tag_me/WelcomePage/WelcomePage.dart';
import 'package:tag_me/SignupPage/SignupPage.dart';
import 'package:tag_me/HomePage/HomePage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tag_me/utilities/Location.dart';
import 'package:tag_me/utilities/eventFunctions.dart';
import 'firebase_options.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await askForLocationPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  listenToEvents();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({Key? key, required this.prefs}) : super(key: key);

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
        HistoryPage.routeName: (context) => const HistoryPage(),
        EditProfilePage.routeName: (context) => const EditProfilePage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
  static const String routeName = '/MainPage';
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentIndex]['title'], style: kappBarTextStyle),
        backgroundColor: kNavbarBackgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.person_2_outlined),
                color: ktextColorWhite,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
      ),
      drawer: const ProfilePage(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomePage(),
          EventsPage(),
          AboutPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: khomePageBackgroundColor,
        color: kNavbarBackgroundColor,
        buttonBackgroundColor: kNavbarButtonBackgroundColor,
        animationDuration: const Duration(milliseconds: 600),
        animationCurve: Curves.easeOut,
        height: 50,
        index: _currentIndex,
        items: _pages
            .map(
              (page) => Icon(page['icon'], size: 30, color: kNavbarButtonColor),
            )
            .toList(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
          );
        },
      ),
    );
  }

  final List<Map<String, dynamic>> _pages = [
    {'title': 'Home', 'icon': Icons.home},
    {'title': 'Events', 'icon': Icons.event},
    {'title': 'About', 'icon': Icons.description},
  ];
}
