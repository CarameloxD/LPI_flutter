import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_presencas/items/classItem.dart';
import 'NavBar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _schedules = [];

  void initState() {
    super.initState();
    this.getStudent();
    this.getSchedulesByStudent();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('dd-MM-yyyy').format(date);
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
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              Text(
                dateFormat,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
              ),
              Flexible(
                child: Container(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final schedule = _schedules[index];
                      return Center(
                        key: Key(schedule['id'].toString()),
                        child: ClassItem(
                          identifier: schedule['identifier'],
                          startingTime:
                              DateTime.parse(schedule['startingTime']),
                          endingTime: DateTime.parse(schedule['endingTime']),
                          name: schedule['name'],
                          type: schedule['type'],
                          teacher: schedule['teacher'],
                        ),
                      );
                    },
                    itemCount: _schedules.length,
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  getStudent() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "studentNumber");
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8081/api/v1/student/$number'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      await storage.write(key: 'name', value: jsonResponse['user']['name']);
      await storage.write(key: 'email', value: jsonResponse['user']['email']);
    }
  }

  getSchedulesByStudent() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "studentNumber");
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8081/api/v1/student/getSchedulesByStudent/$number/'));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> schedules = jsonResponse['schedules'];
      schedules.forEach((schedules) {
        setState(() {
          _schedules.add({
            "id": schedules['Id'],
            "startingTime": schedules['StartingTime'],
            "endingTime": schedules['EndingTime'],
            "name": schedules['Name'],
            "type": schedules['Type'],
            "identifier": schedules['Identifier'],
            "teacher": schedules['Teacher'],
          });
        });
        print("\n");
        print(_schedules);
      });
    }
  }
}
