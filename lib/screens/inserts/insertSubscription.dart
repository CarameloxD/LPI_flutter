import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';

class insertSubscription extends StatefulWidget {
  @override
  _insertSubscriptionState createState() => _insertSubscriptionState();
}

class _insertSubscriptionState extends State<insertSubscription> {
  final _formKey = GlobalKey<FormState>();
  var _idCourse = '';
  final List<Map<String, dynamic>> _courses = [];
  final List<Map> _students = [];
  final List<int> _idStudents = [];

  void initState() {
    super.initState();
    this.getCourses();
    this.getStudents();
  }

  Future<int> attemptInsert(
      List<Map> _studentslist, String idCourse, BuildContext context) async {
    _studentslist.forEach((element) {
      print(element);
      if (element['isChecked'] == true) {
        _idStudents.add(element['key']);
      }
    });
    print(_idStudents);
    final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8081/api/v1/subscription/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'IdCourse': int.parse(idCourse),
          'IdStudents': _idStudents
        }));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscription inserted')),
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
            title: Text('Insert Subscription'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please insert a course';
                    }
                    return null;
                  },
                  icon: Icon(Icons.work),
                  labelText: 'Course',
                  items: _courses,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _idCourse = val;
                    });
                  },
                  onSaved: (val) => print(val),
                ),
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
                        await attemptInsert(_students, _idCourse, context);
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

  getCourses() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8081/api/v1/course/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<dynamic> courses = jsonResponse['courses'];
      courses.forEach((courses) {
        setState(() {
          _courses.add({"value": courses['id'], "label": courses['title']});
        });
      });
    }
  }

  getStudents() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8081/api/v1/student/'));
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
