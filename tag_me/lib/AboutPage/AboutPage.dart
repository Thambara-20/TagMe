// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/constants/line.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);
  static const String routeName = '/AboutPage';

  @override
  // ignore: library_private_types_in_public_api
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.jpg', // Replace with the path to your app's logo
                height: 100,
              ),
              AnimatedStraightLine(width: 300, height: 10),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Tag Me Attendance Marker',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tag Me Attendance Marker is an innovative app designed to simplify attendance tracking for various events and activities. With a user-friendly interface and robust features, Tag Me makes it easy for users to mark their attendance accurately.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Attendance marking is secured using GPS location. You can mark your attendance only when you are physically present at the specified location.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  // url
                },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Learn More'),
                      Icon(Icons.arrow_outward)
                    ],
                  ),
              ),
              const SizedBox(height: 16),
              const Text(
                '© 2024 Tag Me. All rights reserved.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                'For support or inquiries, contact us at support@-.com',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
