import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';
import 'package:sistema_presencas/main.dart';

class insertAttendanceTeacher extends StatefulWidget {
  final String idSchedule;
  insertAttendanceTeacher({required this.idSchedule});

  @override
  _insertAttendanceTeacherState createState() => _insertAttendanceTeacherState(idSchedule: idSchedule);
}

class _insertAttendanceTeacherState extends State<insertAttendanceTeacher> {
  final String idSchedule;
  _insertAttendanceTeacherState({required this.idSchedule});

  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _schedules = [];
  final List<Map> _students = [];
  final List<int> _idStudents = [];

  void initState() {
    super.initState();
    this.getStudentsBySchedule(idSchedule);
  }

  Future<int> attemptInsert(List<Map> _studentslist, BuildContext context) async {
    _studentslist.forEach((element) {
      print(element);
      if (element['isChecked'] == true) {
        _idStudents.add(element['key']);
      }
    });
    print(_idStudents);
    final response = await http.post(
        Uri.parse(SERVER_IP + 'attendance/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'IdSchedule': int.parse(idSchedule),
          'IdStudents': _idStudents
        }));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance inserted')),
      );
      return 1;
    } else {
      print("Request has not been inserted correctly");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Insert Attendance'),
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
                      return CheckboxListTile(
                          value: student['isChecked'],
                          title: Text(student['value']!),
                          onChanged: (newValue) {
                            setState(() {
                              student['isChecked'] = newValue;
                            });
                          });
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        await attemptInsert(_students, context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  getSchedules() async {
    final response =
    await http.get(Uri.parse(SERVER_IP + 'schedule/'));
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
    final response =
    await http.get(Uri.parse(SERVER_IP + 'schedule/$id'));
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
