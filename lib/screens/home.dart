import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_presencas/items/classItem.dart';
import 'NavBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var subject = '', startingTime = '', endingTime = '';

  void initState() {
    super.initState();
    this.getData();
  }

  final List<String> _myList = List.generate(100, (index) => 'Product $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('UFP'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        drawer: NavBar(),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
              ),
              Text("Dia de hoje"),
              Flexible(
                child: Center(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ClassItem();
                    },
                    itemCount: 2,
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  getData() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "studentNumber");
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8081/api/v1/student/$number'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      await storage.write(key: 'name', value: jsonResponse['data']['name']);
      await storage.write(key: 'email', value: jsonResponse['data']['email']);

      setState(() {
        subject = jsonResponse['subjectsName'];
        startingTime = jsonResponse['schedulesStartingTime'];
        endingTime = jsonResponse['schedulesEndingtime'];
      });
    }
  }
}
