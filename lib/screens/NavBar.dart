import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_presencas/screens/schedule.dart';
import 'package:sistema_presencas/screens/settings.dart';
import 'package:sistema_presencas/screens/welcome.dart';

import 'home.dart';


class NavBar extends StatefulWidget {
  //const NavBar({required Key key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final storage = new FlutterSecureStorage();
  var name = '', email = '';

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
                child: Image.network(
                  'https://sic.pt/wp-content/uploads/2022/01/GettyImages-1350241729-scaled.jpg',
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
                    builder: (BuildContext context) => HomeScreen()));
              }
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserProfile()));*/
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Schedule'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ScheduleScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Classes'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Settings()));
              }
          ),
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
      setState(() {
        name = n!;
        email = e!;
      });
  }
}
