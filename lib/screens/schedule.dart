import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'NavBar.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int state = 0;
  final storage = new FlutterSecureStorage();

  Future<int> attemptLogIn(String StudentNumber, BuildContext context) async {
    String? token = await storage.read(key: "token");
    print(token);
    final response = await http
        .get(Uri.parse('https://siws.ufp.pt/api/v1/schedule'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        state = 1;
        var token = json.decode(response.body)['message'];
      }
      return 1;
    } else {
      state = 0;
      print("Incorrect");
      return 0;
    }
  }

  Widget _buildSchedule() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          await attemptLogIn("40155", context);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Schedule',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('UFP')),
      body: Center(
        child: Stack(
          children: <Widget>[
            _buildSchedule(),
          ],
        ),
      ),
      drawer: NavBar(),
    );
  }
}
