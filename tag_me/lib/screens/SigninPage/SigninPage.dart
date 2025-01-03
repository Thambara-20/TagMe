// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/main.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/authService.dart';
import 'package:tag_me/utilities/cache.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const String routeName = '/SignInPage';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ktextColorWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kWelcomePageBackgroundColorI, kWelcomePageBackgroundColorII],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In to Tag Me!',
                style: klargeTextWhiteStyle,
              ),
              SizedBox(height: 0.02 * screenHeight),
              SizedBox(
                width: 0.8 * screenWidth,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: knormalTextWhiteStyle,
                  ),
                  style: knormalTextWhiteStyle,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 0.02 * screenHeight),
              SizedBox(
                width: 0.8 * screenWidth,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: knormalTextWhiteStyle,
                  ),
                  style: knormalTextWhiteStyle,
                  obscureText: true,
                ),
              ),
              SizedBox(height: 0.02 * screenHeight),
              ElevatedButton(
                onPressed: () async {
                  // Call the sign in with email and password method
                  AppUser? user =
                      await FirebaseAuthService().signInWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (user != null) {
                    await storeLoggedInUser(user);
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, MainPage.routeName);
                  } else {
                    // Failed to sign in
                    _showSnackBar("Failed to sign in");
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 0.04 * screenHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: knormalTextWhiteStyle),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/SignUpPage');
                    },
                    child: const Text('Sign Up', style: knormalTextBlueStyle),
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
