import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'NavBar.dart';

class HomeScreenTeacher extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('UFP Teacher')
      ),
      drawer: NavBar(),
    );
  }

  getData() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "studentNumber");
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/v1/home/$number'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      await storage.write(key: 'name', value: jsonResponse['data']['name']);
      await storage.write(key: 'email', value: jsonResponse['data']['email']);
      //await storage.write(key: 'picture', value: jsonResponse['data']['picture']);
    }
  }
}