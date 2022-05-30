import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_presencas/main.dart';
import '../items/classItem.dart';
import '../items/classItemTeacher.dart';
import 'NavBar.dart';
import 'package:intl/intl.dart';

class HomeScreenTeacher extends StatefulWidget {
  const HomeScreenTeacher({Key? key}) : super(key: key);

  @override
  State<HomeScreenTeacher> createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends State<HomeScreenTeacher> {
  final List<Map<String, dynamic>> _schedules = [];

  void initState() {
    super.initState();
    this.getTeacher();
    this.getSchedulesByTeacher();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('dd-MM-yyyy').format(date);
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('UFP Teacher'),
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
                        child: ClassItemTeacher(
                          id: schedule['id'],
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
        )
    );
  }

  getTeacher() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "teacher");
    final response = await http
        .get(Uri.parse(SERVER_IP + 'teacher/$number'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      await storage.write(key: 'name', value: jsonResponse['data']['name']);
      await storage.write(key: 'email', value: jsonResponse['data']['email']);
    }
  }

  getSchedulesByTeacher() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "teacher");
    final response = await http.get(Uri.parse(
        SERVER_IP + 'teacher/getSchedulesByTeacher/$number'));
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
