// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String routeName = '/SignUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                'Sign Up for Tag Me!',
                style: klargeTextWhiteStyle,
              ),
              SizedBox(height: 0.02 * screenHeight),
              SizedBox(
                width: 0.8 * screenWidth,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: knormalTextWhiteStyle,
                  ),
                  style: knormalTextWhiteStyle,
                ),
              ),
              SizedBox(height: 0.02 * screenHeight),
              SizedBox(
                width: 0.8 * screenWidth,
                child: TextFormField(
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
                    onPressed: () {
                     //
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      padding: const EdgeInsets.all(16),
                    ),
                    child:
                        const Text('Sign up', style: TextStyle(fontSize: 16)),
                  ),
              SizedBox(height: 0.04 * screenHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: knormalTextWhiteStyle),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/SignInPage');
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
