import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const String routeName = '/SignInPage';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                'Sign In to Tag Me!',
                style: klargeTextWhiteStyle,
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
                  // Implement sign-in functionality
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(0.7 * screenWidth, 0.06 * screenHeight),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 0.04 * screenWidth),
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
