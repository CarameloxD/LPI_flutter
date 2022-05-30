import 'package:flutter/material.dart';

import 'inserts/insertAttendanceTeacher.dart';

class ClassInfoTeacher extends StatelessWidget {
  final int id, identifier;
  final DateTime startingTime, endingTime;
  final String name, type,teacher;

  ClassInfoTeacher(
      {required this.id,
        required this.identifier,
        required this.startingTime,
        required this.endingTime,
        required this.name,
        required this.type,
        required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Class Info'),
          backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
      body: Container(
        child: Column(
          children: [
            Image.asset("assets/images/fundo.jpeg", scale: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                          "Subject: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                VerticalDivider(width: 0.5),
                Expanded(
                    child: Center(
                      child: Text(name),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                          "Type: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                VerticalDivider(width: 0.5),
                Expanded(
                    child: Center(
                      child: Text(type),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                          "Teacher: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                VerticalDivider(width: 0.5),
                Expanded(child: Center(child: Text(teacher))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                          "Class Time: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                VerticalDivider(width: 0.5),
                Expanded(
                    child: Center(
                        child: Text(
                          startingTime.hour.toString() +
                              ":" +
                              startingTime.minute.toString() +
                              " - " +
                              endingTime.hour.toString() +
                              ":" +
                              endingTime.minute.toString(),
                        ))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                          "Classroom: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                VerticalDivider(width: 0.5),
                Expanded(child: Center(child: Text(identifier.toString()))),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => insertAttendanceTeacher(idSchedule: id.toString())));
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Attend Students', style: TextStyle(fontSize: 15)),
        ),
      ),
    );
  }
}
