import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class insertSchedule extends StatefulWidget {
  @override
  _insertScheduleState createState() => _insertScheduleState();
}

class _insertScheduleState extends State<insertSchedule> {
  final _formKey = GlobalKey<FormState>();
  var _idClass = '', _idClassroom = '', _date, _startingTime, _endingTime;
  final List<Map<String, dynamic>> _classes = [];
  final List<Map<String, dynamic>> _classrooms = [];
  final formatDate = DateFormat("yyyy-MM-dd");
  final formatHour = DateFormat("HH:mm:ss");

  void initState() {
    super.initState();
    this.getClasses();
    this.getClassrooms();
  }

  Future<int> attemptInsert(String idClass, String idClassroom,
      String startingTime, String endingTime, BuildContext context) async {
    final response =
        await http.post(Uri.parse('http://10.0.2.2:8081/api/v1/schedule/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'IdClass': int.parse(idClass),
              'StartingTime': startingTime,
              'EndingTime': endingTime,
              'IdClassroom': int.parse(idClassroom),
            }));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule inserted')),
      );
      return 1;
    } else {
      print("Request has not been inserted correctly");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Insert Schedule'),
            backgroundColor: Color.fromRGBO(56, 180, 74, 1)),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please insert a class';
                    }
                    return null;
                  },
                  icon: Icon(Icons.people),
                  labelText: 'Class',
                  items: _classes,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _idClass = val;
                    });
                  },
                  onSaved: (val) => print(val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please insert a classroom';
                    }
                    return null;
                  },
                  icon: Icon(Icons.meeting_room),
                  labelText: 'Classroom',
                  items: _classrooms,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _idClassroom = val;
                    });
                  },
                  onSaved: (val) => print(val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text('Day'),
                DateTimeField(
                  format: formatDate,
                  onShowPicker: (context, currentValue) async {
                    _date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    return _date;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text('Starting Time'),
                DateTimeField(
                  format: formatHour,
                  onShowPicker: (context, currentValue) async {
                    _startingTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(_startingTime);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text('Ending Time'),
                DateTimeField(
                  format: formatHour,
                  onShowPicker: (context, currentValue) async {
                    _endingTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(_endingTime);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        await attemptInsert(
                            _idClass,
                            _idClassroom,
                            DateTimeField.combine(_date, _startingTime)
                                .toString(),
                            DateTimeField.combine(_date, _endingTime)
                                .toString(),
                            context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  getClasses() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8081/api/v1/class/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> classes = jsonResponse['classes'];
      classes.forEach((classes) {
        setState(() {
          _classes
              .add({"value": classes['id'], "label": classes['classAcronym']});
        });
      });
    }
  }

  getClassrooms() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8081/api/v1/classroom/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> classrooms = jsonResponse['classrooms'];
      classrooms.forEach((classrooms) {
        setState(() {
          _classrooms.add(
              {"value": classrooms['id'], "label": classrooms['identifier']});
        });
      });
    }
  }
}
