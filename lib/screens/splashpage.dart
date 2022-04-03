import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  SplashPage({required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return Scaffold(
        body: Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/fundo.jpeg', fit: BoxFit.cover),
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Column(
                children: [
                  Image.asset('assets/images/ufp.png'),
                  SizedBox(height: 25),
                  new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
                ],
              ))
            ],
          ))
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/fundo.jpeg'), fit: BoxFit.cover),
      ),
    ));
  }
}
