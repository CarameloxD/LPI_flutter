import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class deleteSubjects extends StatefulWidget {
  @override
  _deleteSubjectsState createState() => _deleteSubjectsState();
}

class _deleteSubjectsState extends State<deleteSubjects> {
  final _formKey = GlobalKey<FormState>();
  var _id = '';
  final List<Map> _Subjects = [];

  void initState() {
    super.initState();
    this.getSubjects();
  }

  Future<int> attemptDelete(String id, BuildContext context) async {

    final response = await http.delete(
      Uri.parse(SERVER_IP + 'subject/$id'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject deleted!')),
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
            title: Text('Delete subjects'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        body: ListView.builder(
          itemCount: _Subjects.length,
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
                  attemptDelete(_Subjects[index]["key"].toString(), context);
                  _Subjects.removeAt(index);
                });
              },

              // Display item's title, price...
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(_Subjects[index]["key"].toString()),
                  ),
                  title: Text(_Subjects[index]["value"].toString()),
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

  getSubjects() async {
    final response = await http
        .get(Uri.parse(SERVER_IP + 'subject/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<dynamic> subjects = jsonResponse['subjects'];
      subjects.forEach((subjects) {
        setState(() {
          _Subjects.add({
            "key": subjects['id'],
            "value": subjects['name'],
          });
        });
      });
    }
  }
}
