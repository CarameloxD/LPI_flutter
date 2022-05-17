import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class deleteCourse extends StatefulWidget {
  @override
  _deleteCourseState createState() => _deleteCourseState();
}

class _deleteCourseState extends State<deleteCourse> {
  final _formKey = GlobalKey<FormState>();
  var _id = '';
  final List<Map> _courses = [];

  void initState() {
    super.initState();
    this.getCourses();
  }

  Future<int> attemptDelete(String id, BuildContext context) async {

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8081/api/v1/course/$id'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course deleted!')),
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
            title: Text('Delete Course'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        body: ListView.builder(
          itemCount: _courses.length,
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
                  attemptDelete(_courses[index]["key"].toString(), context);
                  _courses.removeAt(index);
                });
              },

              // Display item's title, price...
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(_courses[index]["key"].toString()),
                  ),
                  title: Text(_courses[index]["value"]),
               //   subtitle: Text("${_students[index]["number"].toString()}"),
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

  getCourses() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8081/api/v1/course/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<dynamic> courses = jsonResponse['courses'];
      courses.forEach((courses) {
        setState(() {
          _courses.add({
            "key": courses['id'],
            "value": courses['title'],
            //"number": students['student_number']
          });
        });
      });
    }
  }
}
