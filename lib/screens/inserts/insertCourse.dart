import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class insertCourse extends StatefulWidget {
  @override
  _insertCourseState createState() => _insertCourseState();
}

class _insertCourseState extends State<insertCourse> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  final TextEditingController _titleController = new TextEditingController();

  Future<int> attemptInsert(String title, BuildContext context) async {
    print(title);
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8081/api/v1/course/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Title': title,
        }));
    _titleController.clear();
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course inserted')),
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
            title: Text('Insert Course'),
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
                  'Name',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert the name of the course';
                  }
                  return null;
                }, onSaved: (value) {
                  setState(() {
                    _title = value!;
                  });
                }),
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
                        await attemptInsert(_title, context);
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
}
