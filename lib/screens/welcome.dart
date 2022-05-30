import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_presencas/screens/HomeScreenAdmin.dart';
import 'package:sistema_presencas/screens/home.dart';
import 'package:sistema_presencas/utilities/constants.dart';
import '../main.dart';
import 'homeTeacher.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _rememberMe = false;
  int state = 0;
  List<String> adminEmails = ['carvalhomiguel17@gmail.com', '5.5antoniodaniel@gmail.com', 'joaopedromelo@live.com.pt'];
  final TextEditingController _usernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _validate_username = false;

  final storage = new FlutterSecureStorage();

  bool isAdmin(String email){
    if (adminEmails.contains(email)){
      return true;
    }
    return false;
  }

  Future<int> attemptLogIn(String username, String password, BuildContext context) async {

    if(isAdmin(username)){
      var response = await http.post(
          Uri.parse(SERVER_IP + 'admin/login'),
          body: convert.jsonEncode(
              <String, String>{"username": username, "password": password}));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          state = 1;
          var token = json.decode(response.body)['token'];
          var email = json.decode(response.body)['email'];
          var nome = json.decode(response.body)['username'];

          await storage.write(key: 'jwt', value: token);
          await storage.write(key: 'email', value: email);
          await storage.write(key: 'admin', value: 'yes');
        }
        return 1;
      } else{
        state = 0;
        print("Incorrect");
        return 0;
      }
    } else{
      print(username);
      final response = await http.post(
        // https://siws.ufp.pt/api/v1/login'
          Uri.parse('https://siws.ufp.pt/api/v1/login'),
          body: {"username": username, "password": password});

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        await storage.write(key: 'studentNumber', value: username);
        print(response.body);
        if (jsonResponse != null) {
          state = 1;
        }
        await storage.write(key: 'admin', value: 'no');
        return 1;
    } else{
        state = 0;
        print("Incorrect");
        return 0;
      }
    }
  }

  _showDialog(context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Error'),
              content: Text('Username or password wrong'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Try again!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Enter your username',
              hintStyle: kHintTextStyle,
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          var username = _usernameController.text;
          var password = _passwordController.text;

          setState(() {});

          if (_validate_username != true && !isAdmin(username)) {
            await attemptLogIn(username, password, context);

            if (state == 0) {
              _showDialog(context); //mensagem de erro ao dar login
            } else if (isNumeric(username)) {
              // Se o username for so numeros, utilizador é um Aluno
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else {
              // Se o username for com letras, utilizador é um Professor
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreenTeacher()),
              );
            }
          } else{
            await attemptLogIn(username, password, context);
            if (state == 0) {
              _showDialog(context); //mensagem de erro ao dar login
            } else{
              // Se o username for um email, utilizador é um Admin
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreenAdmin()),
              );
            }
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Center(
                          child: Container(
                              width: 200,
                              height: 150,
                              /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                              child: Image.asset('assets/images/ufp.png')),
                        ),
                      ),
                      SizedBox(height: 0.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildLoginBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
