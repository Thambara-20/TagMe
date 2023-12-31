import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:tag_me/constants/constants.dart";
import 'package:tag_me/SignupPage/SignupPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const String routeName = '/WelcomePage';

  @override
  State<WelcomePage> createState() => _HomePageState();
}

class _HomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/background.jpg'), 
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
              ElevatedButton(
                onPressed: () {
                   Navigator.pushNamed(context, SignUpPage.routeName);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(0.7 * screenWidth,
                      0.06 * screenHeight), // Adjusted button size
                ),
                child: Text('Sign up',
                    style: TextStyle(fontSize: 0.04 * screenWidth)),
              ),
              SizedBox(height: 0.02 * screenHeight),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for Google Sign In button
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(0.7 * screenWidth,
                      0.06 * screenHeight), // Adjusted button size
                  backgroundColor: kbuttonColorBlue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const FaIcon(FontAwesomeIcons.google, color: ktextColorWhite),
                    SizedBox(width: 0.05 * screenWidth),
                    const Text('Login using Google',
                        style: knormalTextWhiteStyle)
                  ],
                ),
              ),
              SizedBox(height: 0.04 * screenHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: knormalTextWhiteStyle),
                  TextButton(
                    onPressed: () {
                     
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