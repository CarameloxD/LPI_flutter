import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassItem extends StatefulWidget {

  @override
  State<ClassItem> createState() => _ClassItemState();
}

class _ClassItemState extends State<ClassItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditAlarm(alarm: this.alarm, manager: manager))),*/
      child: Builder(
        builder: (context) => Card(
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
                    Text("Nome da Cadeira"),
                    Text(
                      "Hora de inicio-Hora de Fim",
                      //'${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
