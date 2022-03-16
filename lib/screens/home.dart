import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'NavBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var subject = '', startingTime = '', endingTime = '';

  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('UFP')
        ),
        drawer: NavBar(),
        body: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Subject"),
                    Spacer(flex: 1),
                    Text("$subject")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Starting Time"),
                    Spacer(flex: 1),
                    Text("$startingTime")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Ending Time"),
                    Spacer(flex: 1),
                    Text("$endingTime")
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }

  getData() async {
    final storage = new FlutterSecureStorage();
    var number = await storage.read(key: "studentNumber");
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/v1/home/$number'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      await storage.write(key: 'name', value: jsonResponse['data']['name']);
      await storage.write(key: 'email', value: jsonResponse['data']['email']);

      setState(() {
        subject = jsonResponse['schedule subject'];
        startingTime = jsonResponse['schedule start'];
        endingTime = jsonResponse['schedule end'];
      });
      /*if(jsonResponse['data']['picture'] != null) {
        await storage.write(key: 'picture', value: jsonResponse['data']['picture']);
      }*/
    }
  }
}
