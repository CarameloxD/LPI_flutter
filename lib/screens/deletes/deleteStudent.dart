import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utilities/constants.dart';
import '../NavBar.dart';

class deleteStudent extends StatefulWidget {
  @override
  _deleteStudentState createState() => _deleteStudentState();
}

class _deleteStudentState extends State<deleteStudent> {
  final _formKey = GlobalKey<FormState>();
  var _id = '';

  Future<int> attemptDelete(String id, BuildContext context) async {

    final response = await http.delete(
        Uri.parse('http://10.0.2.2:8081/api/v1/student/delete/$id/'),
    );
    print("tou maninho?");
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted!')),
      );
      return 1;
    } else {
      print("Delete failed!");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Delete Student'),
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
                  'Id',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insert the ID of the student to remove';
                      }
                      return null;
                    }, onSaved: (value) {
                  setState(() {
                    _id = value!;
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                        await attemptDelete(
                            _id, context);
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
