import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class deleteTeacher extends StatefulWidget {
  @override
  _deleteTeacherState createState() => _deleteTeacherState();
}

class _deleteTeacherState extends State<deleteTeacher> {
  final _formKey = GlobalKey<FormState>();
  var _id = '';
  final List<Map> _teachers = [];

  void initState() {
    super.initState();
    this.getTeachers();
  }

  Future<int> attemptDelete(String id, BuildContext context) async {

    final response = await http.delete(
      Uri.parse(SERVER_IP + 'teacher/$id'),
    );
    print(id);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher deleted!')),
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
            title: Text('Delete teacher'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        body: ListView.builder(
          itemCount: _teachers.length,
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
                  attemptDelete(_teachers[index]["key"].toString(), context);
                  _teachers.removeAt(index);
                });
              },

              // Display item's title, price...
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(_teachers[index]["key"].toString()),
                  ),
                  title: Text(_teachers[index]["value"]),
                  // subtitle: Text("${_courses[index]["number"].toString()}"),
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

  getTeachers() async {
    final response = await http
        .get(Uri.parse(SERVER_IP + 'teacher/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<dynamic> teachers = jsonResponse['teachers'];
      teachers.forEach((teachers) {
        setState(() {
          _teachers.add({
            "key": teachers['Id'],
            "value": teachers['name'],
          });
        });
      });
    }
  }
}
