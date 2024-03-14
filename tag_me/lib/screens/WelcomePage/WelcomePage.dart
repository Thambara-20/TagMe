// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tag_me/screens/SignupPage/SignupPage.dart';
import 'package:tag_me/screens/SigninPage/SigninPage.dart';
import 'package:tag_me/main.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/authService.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/cache.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const String routeName = '/WelcomePage';

  @override
  State<WelcomePage> createState() => _HomePageState();
}

class _HomePageState extends State<WelcomePage> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn = await checkLoggedInUser();
    //if islogged in navigate to HomePage

    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, MainPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kWelcomePageBackgroundColorI,
              kWelcomePageBackgroundColorII
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Tag Me!',
                style: klargeTextWhiteStyle,
              ),
              SizedBox(height: 0.04 * screenHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpPage.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                      padding: const EdgeInsets.all(16),
                    ),
                    child:
                        const Text('Sign up', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 0.02 * screenHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (isLoggedIn) {
                          Navigator.pushNamed(context, MainPage.routeName);
                        } else {
                          FirebaseAuthService authService =
                              FirebaseAuthService();
                          AppUser? user = await authService.signInWithGoogle();
                          if (user != null) {
                            await storeLoggedInUser(user);
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, MainPage.routeName);
                          }
                        }
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to logged in')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: kbuttonColorBlue,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FaIcon(FontAwesomeIcons.google, color: ktextColorWhite),
                        SizedBox(width: 15),
                        Text('Login using Google', style: knormalTextWhiteStyle)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.04 * screenHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: knormalTextWhiteStyle),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignInPage.routeName);
                    },
                    child: const Text('Sign In', style: knormalTextBlueStyle),
                  ),
                ],
              ),
              const Text(
                'Developed by Leo Club of UOM',
                style: knormalTextGreyStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
