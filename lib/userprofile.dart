import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

import 'Widgets/loadingWidget.dart';
import 'app_drawer.dart';
import 'appbarcolor.dart';
import 'globalVar.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  // TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  bool _displayNameValid = true;
  bool _bioValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('userss')
        .doc(userId)
        .get()
        .then((results) {
      setState(() {
        userImageUrl = results.data()['imgPro'];
        userNames = results.data()['userNames'];
      });
    });
    displayNameController.text = userNames;

    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        // TextField(
        //   controller: bioController,
        //   decoration: InputDecoration(
        //     hintText: "Update Bio",
        //     errorText: _bioValid ? null : "Bio too long",
        //   ),
        // )
      ],
    );
  }

  updateProfileData(String sujal) {
    setState(() {
      sujal.trim().length < 3 || displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
    });

    if (_displayNameValid) {
      FirebaseFirestore.instance.collection('userss').doc(userId).update({
        "userNames": displayNameController.text,
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () => Navigator.pop(context),
          //   icon: Icon(
          //     Icons.done,
          //     size: 30.0,
          //     color: Colors.green,
          //   ),
          // ),
        ],
        flexibleSpace: colorapp,
      ),
      drawer: AppDrawer(usere: userEmail, usern: userNames),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     top: 16.0,
                      //     bottom: 8.0,
                      //   ),
                      //   child: CircleAvatar(
                      //     radius: 50.0,
                      //     backgroundImage:
                      //         CachedNetworkImageProvider(user.photoUrl),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      TextButton(
                        // onPressed: updateProfileData,
                        onPressed: () {
                          updateProfileData(displayNameController.text);
                          print(displayNameController.text);
                        },
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
