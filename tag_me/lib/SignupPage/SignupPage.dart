// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_me/SigninPage/SigninPage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/authService.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String routeName = '/SignUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isRetypePasswordValid = true;

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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kiconColorWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up for Tag Me!',
                  style: klargeTextWhiteStyle,
                ),
                SizedBox(height: 0.02 * screenHeight),
                SizedBox(
                  width: 0.8 * screenWidth,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: knormalTextWhiteStyle,
                      errorText: _isEmailValid ? null : 'Invalid email format',
                    ),
                    style: knormalTextWhiteStyle,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        _isEmailValid = RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                            .hasMatch(value);
                      });
                    },
                  ),
                ),
                SizedBox(height: 0.02 * screenHeight),
                SizedBox(
                  width: 0.8 * screenWidth,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: knormalTextWhiteStyle,
                      errorText: _isPasswordValid
                          ? null
                          : 'Password must be at least 6 characters long',
                    ),
                    style: knormalTextWhiteStyle,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _isPasswordValid = value.length >= 6;
                      });
                    },
                  ),
                ),
                SizedBox(height: 0.02 * screenHeight),
                SizedBox(
                  width: 0.8 * screenWidth,
                  child: TextFormField(
                    controller: _retypePasswordController,
                    decoration: InputDecoration(
                      labelText: 'Retype Password',
                      labelStyle: knormalTextWhiteStyle,
                      errorText: _isRetypePasswordValid
                          ? null
                          : 'Passwords do not match',
                    ),
                    style: knormalTextWhiteStyle,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _isRetypePasswordValid =
                            value == _passwordController.text;
                      });
                    },
                  ),
                ),
                SizedBox(height: 0.04 * screenHeight),
                ElevatedButton(
                  onPressed: () async {
                    User? user =
                        await FirebaseAuthService().signUpWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (user != null) {
                      await user.sendEmailVerification();

                      _showSnackBar(
                          "Verification email sent. Please check your email to verify your account.");
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, SignInPage.routeName);
                    } else {
                      _showSnackBar("Failed to sign up");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Sign up', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 0.04 * screenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: knormalTextWhiteStyle),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, SignInPage.routeName);
                      },
                      child: const Text('Sign In', style: knormalTextBlueStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
