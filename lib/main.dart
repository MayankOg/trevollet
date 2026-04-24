import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:trevollet/splashActivity.dart';

import 'carousel.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trevollet',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // show splash first
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TrevolletSplash(
      isLoader: false,
      splashDuration: const Duration(seconds: 3),
      onSplashComplete: () {
        // Navigate to your main app screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TravelCarousel(), // 👈 load your carousel
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MyApp());
}