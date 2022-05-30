import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';
import 'package:sistema_presencas/main.dart';

class classStudents extends StatefulWidget {
  final String idSchedule;

  classStudents({required this.idSchedule});

  @override
  _classStudentsState createState() =>
      _classStudentsState(idSchedule: idSchedule);
}

class _classStudentsState extends State<classStudents> {
  final String idSchedule;

  _classStudentsState({required this.idSchedule});

  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _schedules = [];
  final List<Map> _students = [];

  void initState() {
    super.initState();
    this.getStudentsBySchedule(idSchedule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Students Class'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                ),
                Expanded(
                  child: ListView(
                    children: _students.map((student) {
                      return ListTile(
                        title: Text(student['value']!),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  getSchedules() async {
    final response = await http.get(Uri.parse(SERVER_IP + 'schedule/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      print("\n");
      List<dynamic> schedules = jsonResponse['schedules'];
      schedules.forEach((schedules) {
        setState(() {
          _schedules.add({
            "value": schedules['Id'],
            "label": schedules['ClassAcronym'] +
                " | " +
                DateTime.parse(schedules['StartingTime']).day.toString() +
                "/" +
                DateTime.parse(schedules['StartingTime']).month.toString() +
                "/" +
                DateTime.parse(schedules['StartingTime']).year.toString() +
                " | " +
                DateTime.parse(schedules['StartingTime']).hour.toString() +
                ":" +
                DateTime.parse(schedules['StartingTime']).minute.toString()
          });
        });
      });
      print(_schedules);
    }
  }

  getStudentsBySchedule(String id) async {
    final response = await http.get(Uri.parse(SERVER_IP + 'schedule/$id'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<dynamic> students = jsonResponse['students'];
      students.forEach((students) {
        setState(() {
          _students.add({
            "key": students['id'],
            "value": students['name'],
            "isChecked": false
          });
        });
      });
    }
  }
}
