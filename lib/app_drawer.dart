import 'package:bike_mart/HomeScreen.dart';
import 'package:bike_mart/Map.dart';
import 'package:bike_mart/profileScreen.dart';
import 'package:bike_mart/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'authenticationScreen.dart';
import 'globalVar.dart';
// import 'package:provider/provider.dart';

// import '../screens/user_products_screen.dart';
// import '../screens/orders_screen.dart';
// import '../providers/auth.dart';
// import '../helpers/custom_slide_route.dart';

class AppDrawer extends StatefulWidget {
  final String usern;
  final String usere;
  const AppDrawer({Key key, this.usere, this.usern}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String _message;
    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          _message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          _message = 'Good Afternoon';
        } else {
          _message = 'Good Evening';
        }
      },
    );
    return Drawer(
      child: Container(
        width: 50,
        child: Column(
          children: <Widget>[
            // AppBar(
            //   title: Text("Hey there check it out!"),
            //   automaticallyImplyLeading: false,
            // ),
            _createHeader(_message +
                " " +
                (widget.usern[0].toUpperCase() + widget.usern.substring(1)) +
                " Ji"),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HomeScreen()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text("Maps"),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new Maps()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text("profile"),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new EditProfile()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Manage Bikes"),
              onTap: () {
                Route newRoute = MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          sellerId: userId,
                        ));
                Navigator.pushReplacement(context, newRoute);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                _showDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: new Text("Logout"),
          content: new Text("Are you sure you want to Logout"),
          actions: <Widget>[
            new TextButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("Yes"),
              onPressed: () {
                auth.signOut().then((_) {
                  Route newRoute =
                      MaterialPageRoute(builder: (_) => AuthenticationScreen());
                  Navigator.pushReplacement(context, newRoute);
                });
              },
            )
          ],
        );
      },
    );
  }

  Widget _createHeader(String message) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(color: Colors.blue),
        child: Stack(children: <Widget>[
          Container(
            //width: MediaQuery.of(context).size.width/1.3,
            alignment: Alignment.center,
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text(widget.usere,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }
}
