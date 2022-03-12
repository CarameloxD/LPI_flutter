import 'package:flutter/material.dart';
import 'package:sistema_presencas/screens/theme.dart';
import 'package:sistema_presencas/screens/welcome.dart';
import '../utilities/jwt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class NavBar extends StatefulWidget {
  //const NavBar({required Key key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  String picture = '', name = '', email = '';

  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Miguel Carvalho'),
            accountEmail: Text('40113@ufp.edu.pt'),
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
            title: Text('Favorites'),
            onTap: () => null,
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
            leading: Icon(Icons.share),
            title: Text('Share'),
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
            onTap: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>theme()));
            }
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () => null,
          ),
          Divider(),
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

  getData() async {
    final storage = new FlutterSecureStorage();
    var jwt = await storage.read(key: "jwt");
    picture = (await storage.read(key: "picture"))!;
    var results = parseJwtPayLoad(jwt!);
    email = results['email'];
    name = results['name'];
  }
}
