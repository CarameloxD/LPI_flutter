import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show base64, base64Encode;
import '../../main.dart';
import 'dart:convert' as convert;

import '../items/displayImage.dart';
import 'NavBar.dart';

class UserProfilePage extends StatefulWidget {
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final storage = new FlutterSecureStorage();
  var picture = '';

  void initState() {
    super.initState();
    this.getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Profile'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        drawer: NavBar(),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
              ),
              Container(
                height: 100,
                child: InkWell(
                    child: DisplayImage(
                  imagePath: picture,
                )),
              ),
            ],
          ),
        ));
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/fundo.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  getInfo() async {
    var p = await storage.read(key: 'picture');

    setState(() {
      picture = p!;
    });
  }
}
