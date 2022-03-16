import 'package:flutter/material.dart';
import 'package:sistema_presencas/screens/home.dart';
import 'package:sistema_presencas/screens/schedule.dart';
import 'package:sistema_presencas/screens/settings.dart';
import 'package:sistema_presencas/screens/welcome.dart';
import 'package:sistema_presencas/screens/splashpage.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => SplashPage(duration: 3, goToPage: WelcomeScreen()),
      '/welcomepage': (context) => WelcomeScreen(),
      '/home': (context) => HomeScreen(),
      //'/profile': (context) => UserProfile(),
      '/schedule': (context) => ScheduleScreen(),
      '/settings': (context) => Settings(),
    },
  ));
}

