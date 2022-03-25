import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'NavBar.dart';

class insertStudent extends StatefulWidget {
  @override
  _insertStudentState createState() => _insertStudentState();
}

class _insertStudentState extends State<insertStudent> {
  final _formKey = GlobalKey<FormState>();
  var _name = '', _email = '', _studentNumber = 0;


  Future<int> attemptInsert(String name, String email, int studentNumber,
      BuildContext context) async {
    print(name);
    print(email);
    print(studentNumber);
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8081/api/v1/home/insertStudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'student_number': studentNumber
        }));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print("tou maninho");
      print(jsonResponse);
      return 1;
    } else {
      print("Request has not been inserted correctly");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('Insert Student')),
        drawer: NavBar(),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert a name';
                  }
                  return null;
                }, onSaved: (value) {
                  setState(() {
                    _name = value!;
                  });
                }),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert an email';
                  }
                  return null;
                }, onSaved: (value) {
                  setState(() {
                    _email = value!;
                  });
                }),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert a student number';
                  }
                  return null;
                }, onSaved: (value) {
                  setState(() {
                    _studentNumber = int.parse(value!);
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                        await attemptInsert(
                            _name, _email, _studentNumber, context);
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
}
