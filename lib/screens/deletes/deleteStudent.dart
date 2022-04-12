import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class deleteStudent extends StatefulWidget {
  @override
  _deleteStudentState createState() => _deleteStudentState();
}

class _deleteStudentState extends State<deleteStudent> {
  final _formKey = GlobalKey<FormState>();
  var _id = '';
  final List<Map> _students = [];

  void initState() {
    super.initState();
    this.getStudents();
  }

  Future<int> attemptDelete(String id, BuildContext context) async {

    final response = await http.delete(
        Uri.parse('http://10.0.2.2:8081/api/v1/student/$id'),
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
        body: ListView.builder(
          itemCount: _students.length,
          itemBuilder: (BuildContext ctx, index) {
            // Display the list item
            return Dismissible(
              key: UniqueKey(),

              // only allows the user swipe from right to left
              direction: DismissDirection.endToStart,

              // Remove this product from the list
              // In production enviroment, you may want to send some request to delete it on server side
              onDismissed: (_) {
                setState(() {
                  attemptDelete(_students[index]["key"].toString(), context);
                  _students.removeAt(index);
                });
              },

              // Display item's title, price...
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(_students[index]["key"].toString()),
                  ),
                  title: Text(_students[index]["value"]),
                  subtitle: Text("${_students[index]["number"].toString()}"),
                  trailing: const Icon(Icons.arrow_back),
                ),
              ),
              // This will show up when the user performs dismissal action
              // It is a red background and a trash icon
              background: Container(
                color: Colors.red,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            );
          },
        ));
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
            "number": students['student_number']
          });
        });
      });
    }
  }
}
