// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_me/screens/EventsPage/EventsPage.dart';
import 'package:tag_me/screens/ProfilePage/EditProfilePage.dart';
import 'package:tag_me/screens/ProfilePage/ProfilePage.dart';
import 'package:tag_me/screens/SigninPage/SigninPage.dart';
import 'package:tag_me/screens/WelcomePage/WelcomePage.dart';
import 'package:tag_me/screens/SignupPage/SignupPage.dart';
import 'package:tag_me/screens/HomePage/HomePage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tag_me/utilities/cache.dart';
import 'package:tag_me/utilities/locationService.dart';
import 'package:tag_me/utilities/eventServices.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = await checkLoggedInUser() || false;

    await askForLocationPermission();
    await getEventLocationRange();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    listenToEvents();
    runApp(MyApp(prefs: prefs, isLoggedIn: isLoggedIn));
  } catch (e) {
    Logger().e("Error initializing app: $e");
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool isLoggedIn;

  const MyApp({Key? key, required this.prefs, required this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? MainPage.routeName : WelcomePage.routeName,
      routes: {
        WelcomePage.routeName: (context) => const WelcomePage(),
        HomePage.routeName: (context) => const HomePage(),
        EventsPage.routeName: (context) => const EventsPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        SignInPage.routeName: (context) => const SignInPage(),
        MainPage.routeName: (context) => const MainPage(),
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
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: kNavbarIconBackgroundColor,
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
  ];
}
