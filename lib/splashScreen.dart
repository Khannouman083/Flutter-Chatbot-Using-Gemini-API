import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gemini_ai/uiScreen.dart';
import 'package:lottie/lottie.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),() {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const uiScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
                width: 150,
                child: Image.asset('assets/icon.png')).animate().rotate(
              duration: 1.seconds
            ).scale()
          ],
        ),
      ),
    );
  }
}
