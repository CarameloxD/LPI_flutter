import 'package:flutter/material.dart';

class theme extends StatefulWidget {
  const theme({Key? key}) : super(key: key);

  @override
  _themeState createState()=> _themeState();
}



class _themeState extends State<theme> {
  bool _isActive = false;
  ThemeData _dark = ThemeData(brightness: Brightness.dark);
  ThemeData _light = ThemeData(brightness: Brightness.light);
  @override
  Widget build(BuildContext context){

    return MaterialApp(
      theme: _isActive ? _dark : _light,
      home: Scaffold(
        appBar: AppBar(
            title: Text("Mudar tema de fundo")
        ),
        body: Center(
          child: SwitchListTile(
            title: Text('Ativar modo escuro'),
            activeColor: Colors.black,
            value: _isActive,
              onChanged: (value){
                setState((){
                  _isActive = value;
            });
          },
        )
      )
     )
    );
  }
}

