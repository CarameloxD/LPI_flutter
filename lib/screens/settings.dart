import 'package:flutter/material.dart';

import 'NavBar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _settingsState createState()=> _settingsState();
}

class _settingsState extends State<Settings> {
  bool _isActive = false;
  ThemeData _dark = ThemeData(brightness: Brightness.dark);
  ThemeData _light = ThemeData(brightness: Brightness.light);
  @override
  Widget build(BuildContext context){

    return MaterialApp(
      theme: _isActive ? _dark : _light,
      home: Scaffold(
        appBar: AppBar(
            title: Text("Settings")
        ),
        body: Center(
          child: SwitchListTile(
            title: Text('Dark Mode'),
            activeColor: Colors.black,
            value: _isActive,
              onChanged: (value){
                setState((){
                  _isActive = value;
            });
          },
        )
      ),
        drawer: NavBar(),
     )
    );
  }
}

