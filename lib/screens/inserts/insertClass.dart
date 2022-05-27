import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';

class insertClass extends StatefulWidget {
  @override
  _insertClassState createState() => _insertClassState();
}

class _insertClassState extends State<insertClass> {
  final _formKey = GlobalKey<FormState>();
  var _ClassName = '', _idSubject = '', _idTeacher = '';
  final List<Map<String, dynamic>> _subjects = [];
  final List<Map<String, dynamic>> _teachers = [];
  final TextEditingController _classController = new TextEditingController();

  void initState() {
    super.initState();
    this.getSubjects();
    this.getTeachers();
  }

  Future<int> attemptInsert(String ClassName, String idSubject, String idTeacher,BuildContext context) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8081/api/v1/class/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'ClassAcronym': ClassName,
          'IdSubject': int.parse(idSubject),
          'IdTeacher': int.parse(idTeacher),
        }));
    _classController.clear();
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class inserted')),
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
            title: Text('Insert Class'),
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
                Text(
                  'Class Name',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  controller: _classController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert a name for the class';
                  }
                  return null;
                }, onSaved: (value) {
                  setState(() {
                    _ClassName = value!;
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please insert a subject';
                    }
                    return null;
                  },
                  icon: Icon(Icons.subject),
                  labelText: 'Subject',
                  items: _subjects,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _idSubject = val;
                    });
                  },
                  onSaved: (val) => print(val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please insert a teacher';
                    }
                    return null;
                  },
                  icon: Icon(Icons.account_circle),
                  labelText: 'Teacher',
                  items: _teachers,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _idTeacher = val;
                    });
                  },
                  onSaved: (val) => print(val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
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
                        await attemptInsert(_ClassName, _idSubject, _idTeacher,context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  getSubjects() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8081/api/v1/subject/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> subjects = jsonResponse['subjects'];
      subjects.forEach((subjects) {
        setState(() {
          _subjects.add({"value": subjects['id'], "label": subjects['name']});
        });
      });
    }
  }

  getTeachers() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8081/api/v1/teacher/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> teachers = jsonResponse['teachers'];
      teachers.forEach((teachers) {
        setState(() {
          _teachers.add({"value": teachers['Id'], "label": teachers['name']});
        });
      });
    }
  }
}
