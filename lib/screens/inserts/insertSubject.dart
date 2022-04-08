import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';

class insertSubject extends StatefulWidget {
  @override
  _insertSubjectState createState() => _insertSubjectState();
}

class _insertSubjectState extends State<insertSubject> {
  final _formKey = GlobalKey<FormState>();
  var _name = '', _type = '', _idCourse = '';
  final List<Map<String, dynamic>> _courses = [];

  void initState() {
    super.initState();
    this.getCourses();
  }

  Future<int> attemptInsert(
      String name, String type, String idCourse, BuildContext context) async {
    print(name);
    print(type);
    print(idCourse);
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8081/api/v1/subject/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Name': name,
          'Type': type,
          'IdCourse': int.parse(idCourse)
        }));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject inserted')),
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
            title: Text('Insert Subject'),
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
                Text(
                  'Name of Subject',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert the subject`s name';
                  }
                  return null;
                }, onSaved: (value) {
                  setState(() {
                    _name = value!;
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                Text(
                  'Type',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Column(children: [
                  Row(children: [
                    SizedBox(
                      width: 10,
                      child: Radio(
                        value: 'TP',
                        groupValue: _type,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          //value may be true or false
                          setState(() {
                            _type = value as String;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text('TP'),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0)),
                    SizedBox(
                      width: 10,
                      child: Radio(
                        value: 'PL',
                        groupValue: _type,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          //value may be true or false
                          setState(() {
                            _type = value as String;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text('PL')
                  ]),
                ]),
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
                        await attemptInsert(_name, _type, _idCourse, context);
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
}
