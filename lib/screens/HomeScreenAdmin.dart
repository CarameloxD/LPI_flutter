import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'NavBarAdmin.dart';

class HomeScreenAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Admin'),
          backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
      drawer: NavBarAdmin(),
    );
  }

  getData() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "studentNumber");
    final response =
        await http.get(Uri.parse(SERVER_IP + 'home/$number'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      await storage.write(key: 'name', value: jsonResponse['data']['name']);
      await storage.write(key: 'email', value: jsonResponse['data']['email']);
      //await storage.write(key: 'picture', value: jsonResponse['data']['picture']);
    }
  }
}
