import 'package:flutter/material.dart';
import 'package:tag_me/SigninPage/SigninPage.dart';
import 'package:tag_me/WelcomePage/WelcomePage.dart';
import 'package:tag_me/SignupPage/SignupPage.dart';

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
        SignUpPage.routeName: (context) => const SignUpPage(),
        SignInPage.routeName: (context) => const SignInPage(),

      },
    );
  }
}

