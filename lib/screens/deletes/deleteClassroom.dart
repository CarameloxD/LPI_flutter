import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class deleteClassroom extends StatefulWidget {
  @override
  _deleteClassroomState createState() => _deleteClassroomState();
}

class _deleteClassroomState extends State<deleteClassroom> {
  final _formKey = GlobalKey<FormState>();
  var _id = '';
  final List<Map> _Classrooms = [];

  void initState() {
    super.initState();
    this.getClassrooms();
  }

  Future<int> attemptDelete(String id, BuildContext context) async {

    final response = await http.delete(
      Uri.parse(SERVER_IP + 'classroom/$id'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Classrooms deleted!')),
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
            title: Text('Delete classroom'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        body: ListView.builder(
          itemCount: _Classrooms.length,
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
                  attemptDelete(_Classrooms[index]["key"].toString(), context);
                  _Classrooms.removeAt(index);
                });
              },

              // Display item's title, price...
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(_Classrooms[index]["key"].toString()),
                  ),
                  title: Text(_Classrooms[index]["value"].toString()),
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

  getClassrooms() async {
    final response = await http
        .get(Uri.parse(SERVER_IP + 'classroom/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<dynamic> classrooms = jsonResponse['classrooms'];
      classrooms.forEach((classrooms) {
        setState(() {
          _Classrooms.add({
            "key": classrooms['id'],
            "value": classrooms['identifier'],
          });
        });
      });
    }
  }
}
