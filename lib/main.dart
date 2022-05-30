import 'package:flutter/material.dart';
import 'package:sistema_presencas/screens/home.dart';
import 'package:sistema_presencas/screens/schedule.dart';
import 'package:sistema_presencas/screens/settings.dart';
import 'package:sistema_presencas/screens/welcome.dart';
import 'package:sistema_presencas/screens/splashpage.dart';

const SERVER_IP = 'https://40fa-2001-8a0-e7c4-5900-39b8-bb0e-e7b7-2e70.eu.ngrok.io/api/v1/';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/welcomepage',
    routes: {
      '/welcomepage': (context) => SplashPage(duration: 3, goToPage: WelcomeScreen()),
      '/home': (context) => HomeScreen(),
      //'/profile': (context) => UserProfile(),
      '/schedule': (context) => ScheduleScreen(),
      '/settings': (context) => Settings(),
    },
  ));
}

