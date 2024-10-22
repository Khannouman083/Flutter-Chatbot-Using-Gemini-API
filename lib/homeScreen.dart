import 'package:flutter/material.dart';
import 'package:gemini_ai/splashScreen.dart';
import 'package:gemini_ai/uiScreen.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: splashScreen(),
    );
  }
}
