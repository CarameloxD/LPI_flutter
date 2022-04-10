import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassItem extends StatelessWidget {
  final int identifier;
  final DateTime startingTime, endingTime;
  final String name;

  ClassItem(
      {required this.identifier, required this.startingTime, required this.endingTime, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditAlarm(alarm: this.alarm, manager: manager))),*/
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
                    Icon(
                      Icons.event,
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
