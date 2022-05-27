import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistema_presencas/screens/ClassInfo.dart';

import '../screens/scanner.dart';


class ClassItem extends StatelessWidget {
  final int identifier;
  final DateTime startingTime, endingTime;
  final String name, type,teacher;

  ClassItem(
      {required this.identifier, required this.startingTime, required this.endingTime, required this.name, required this.type, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ClassInfo(identifier: identifier, startingTime: startingTime, endingTime: endingTime, name: name, type: type,teacher: teacher))),
      child: Builder(
        builder: (context) =>
            Card(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("$name"),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                        ),
                        Text(
                          startingTime.hour.toString() + ":" + startingTime.minute.toString() + " - " + endingTime.hour.toString() + ":" + endingTime.minute.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                        ),
                        Text("Sala: $identifier"),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.event),
                      onPressed: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Scanner()));
                      }
                    )

                  ],
                ),
              ),
            ),
      ),
    );
  }
}
