import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../NavBar.dart';

class insertSubscription extends StatefulWidget {
  @override
  _insertSubscriptionState createState() => _insertSubscriptionState();
}

class _insertSubscriptionState extends State<insertSubscription> {
  final _formKey = GlobalKey<FormState>();
  var _idClass = 0, _idStudent = 0;

  Future<int> attemptInsert(
      int idClass, int idStudent, BuildContext context) async {
    print(idClass);
    print(idStudent);
    final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8081/api/v1/subscription/insertSubscription'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{'IdClass': idClass, 'IdStudent': idStudent}));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscription inserted')),
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
            title: Text('Insert Subscription'),
            backgroundColor: Colors.green),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
                Text(
                  'Class Name',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert a name for the class';
                  }
                  return null;
                }, onSaved: (value) {
                  setState(() {
                    //_ClassName = value!;
                  });
                }),
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
                        await attemptInsert(_idClass, _idStudent, context);
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
}
