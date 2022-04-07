import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_presencas/screens/HomeScreenAdmin.dart';
import 'package:sistema_presencas/screens/schedule.dart';
import 'package:sistema_presencas/screens/settings.dart';
import 'package:sistema_presencas/screens/welcome.dart';
import 'package:sistema_presencas/screens/inserts/insertStudent.dart';
import 'welcome.dart';
import 'home.dart';
import 'insertMenu.dart';

class NavBarAdmin extends StatefulWidget {
  //const NavBar({required Key key}) : super(key: key);

  @override
  _NavBarAdminState createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  final storage = new FlutterSecureStorage();
  var name = '', email = '', picture = '';


  void initState() {
    super.initState();
    this.getInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("$name"),
            accountEmail: Text("$email"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/defaultPhoto.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreenAdmin()));
              }),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserProfile()));*/
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text('Insert Menu'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => InsertMenu()));
            },
          ),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Settings()));
              }),
          ListTile(
              title: Text('Exit'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              }),
        ],
      ),
    );
  }

  getInfo() async {
    var n = await storage.read(key: 'name');
    var e = await storage.read(key: 'email');
    //var p = await storage.read(key: 'picture');


    setState(() {
      name = n!;
      email = e!;
      //picture = p!;
    });
  }
}
