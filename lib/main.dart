import 'package:flutter/material.dart';
import 'package:sistema_presencas/screens/home.dart';
import 'package:sistema_presencas/screens/welcome.dart';
import 'package:sistema_presencas/screens/splashpage.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashPage(duration: 3, goToPage: WelcomeScreen()),
  ));
}

