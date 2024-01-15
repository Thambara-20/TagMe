// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tag_me/HomePage/HomePage.dart';
import "package:tag_me/constants/constants.dart";
import 'package:tag_me/SignupPage/SignupPage.dart';
import 'package:tag_me/SigninPage/SigninPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const String routeName = '/WelcomePage';

  @override
  State<WelcomePage> createState() => _HomePageState();
}

class _HomePageState extends State<WelcomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  
  Future<User?> _handleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (error) {
      print(error);
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
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
                      User? user = await _handleSignIn();
                      if (user != null) {
                        Navigator.pushNamed(context, HomePage.routeName);
                      } else {
                        print('Gmail signup failed.');
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
            ],
          ),
        ),
      ),
    );
  }
}
