import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'NavBar.dart';


class insertClassroom extends StatefulWidget {
  @override
  _insertClassroomState createState() => _insertClassroomState();
}

bool _isInteger(double value) => value == value.toInt();

class _insertClassroomState extends State<insertClassroom> {
  final _formKey = GlobalKey<FormState>();
  var _identifier = 0, _capacity = 0;


  Future<int> attemptInsert(int identifier, int capacity,
      BuildContext context) async {


    final response = await http.post(
        Uri.parse('http://10.0.2.2:8081/api/v1/home/insertClassroom'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'identifier': identifier,
          'capacity': capacity,
        }));

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);

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
        appBar: AppBar(centerTitle: true, title: Text('Insert Identifier')),
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
                        return 'Please insert an identifier';
                      }
                      return null;
                    }, onSaved: (value) {
                  setState(() {
                    _identifier = int.parse(value!);
                  });
                }),
                TextFormField(
                  // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert a capacity';
                      }
                      return null;
                    }, onSaved: (value) {
                  setState(() {
                    _capacity = int.parse(value!);
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
                            _identifier, _capacity, context);
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
