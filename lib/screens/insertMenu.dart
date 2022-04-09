import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'inserts/insertAttendance.dart';
import 'inserts/insertClass.dart';
import 'inserts/insertClassroom.dart';
import 'inserts/insertCourse.dart';
import 'inserts/insertSchedule.dart';
import 'inserts/insertStudent.dart';
import 'inserts/insertSubject.dart';
import 'inserts/insertSubscription.dart';
import 'inserts/insertTeacher.dart';

class InsertMenu extends StatefulWidget {
  @override
  _InsertMenuState createState() => _InsertMenuState();
}

class _InsertMenuState extends State<InsertMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Insert Menu'),
          backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
      drawer: NavBar(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Student", Icons.school, insertStudent()),
            makeDashboardItem("Course", Icons.work, insertCourse()),
            makeDashboardItem("Subscription", Icons.people_alt_outlined, insertSubscription()),
            makeDashboardItem("Subject", Icons.subject, insertSubject()),
            makeDashboardItem("Teacher", Icons.account_circle, insertTeacher()),
            makeDashboardItem("Class", Icons.people, insertClass()),
            makeDashboardItem("Classroom", Icons.meeting_room, insertClassroom()),
            makeDashboardItem("Schedule", Icons.event, insertSchedule()),
            makeDashboardItem("Attendance", Icons.event_available, insertAttendance()),
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon, Widget screen) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: new InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => screen));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                ),
              ],
            ),
          ),
        ));
  }
}
