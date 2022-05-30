import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';

import '../../main.dart';

class deleteSchedule extends StatefulWidget {
  @override
  _deleteScheduleState createState() => _deleteScheduleState();
}

class _deleteScheduleState extends State<deleteSchedule> {
  final _formKey = GlobalKey<FormState>();
  var _idClass = '';
  final List<Map<String, dynamic>> _classes = [];
  final List<Map> _schedules = [];
  final List<int> _idSchedules = [];


  void initState() {
    super.initState();
    this.getClasses();
  }

  Future<int> attemptDelete(List<Map> _scheduleslist, String idClass, BuildContext context) async {
    _scheduleslist.forEach((element) {
      print(element);
      if (element['isChecked'] == true) {
        _idSchedules.add(element['key']);
      }
    });
    final response = await http.delete(
        Uri.parse(
            SERVER_IP + 'schedule/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'IdClass': int.parse(idClass),
          'IdSchedules': _idSchedules
        }));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule deleted')),
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
            title: Text('Delete Schedule'),
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
                  icon: Icon(Icons.work),
                  labelText: 'Class',
                  items: _classes,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _idClass = val;
                      getSchedules(_idClass);
                    });
                  },
                  onSaved: (val) => print(val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                ),
                Expanded(

                  child: ListView(
                    children: _schedules.map((schedule) {
                      return CheckboxListTile(
                          value: schedule['isChecked'],
                          title: Text(schedule['value']),
                          onChanged: (newValue) {
                            setState(() {
                              schedule['isChecked'] = newValue;
                            });
                          });
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                        await attemptDelete(_schedules, _idClass, context);
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
    await http.get(Uri.parse(SERVER_IP + 'class/'));
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


  getSchedules(String id) async {
    final response = await http
        .get(Uri.parse(SERVER_IP + 'schedule/getSchedulesByClass/$id'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      List<dynamic> schedules = jsonResponse['schedules'];
      schedules.forEach((schedules) {
        setState(() {
          _schedules.add({
            "key": schedules['Id'],
            "value": schedules['Name'],
            "isChecked": false
          });
        });
      });
    }
  }
}