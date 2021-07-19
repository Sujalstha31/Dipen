import 'package:bike_mart/HomeScreen.dart';
import 'package:bike_mart/functions.dart';
import 'package:bike_mart/globalVar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as tAgo;

import 'app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  String sellerId;
  ProfileScreen({this.sellerId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  String userNumber;
  String carPrice;
  String carModel;
  String carlocation;
  String carColor;
  String description;
  String urlImage;
  QuerySnapshot cars;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController priceBikeController = TextEditingController();
  TextEditingController bikeNameController = TextEditingController();
  TextEditingController bikeColorController = TextEditingController();
  TextEditingController descriptionBikeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  carMethods carObj = new carMethods();

  Future<bool> showDialogForUpdateData(selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Update the Ad",
              style: TextStyle(
                  fontSize: 24, fontFamily: "Bebas", letterSpacing: 2.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Enter your name'),
                    onChanged: (value) {
                      this.userName = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: phoneController,
                    decoration:
                        InputDecoration(hintText: 'Enter your phone number'),
                    onChanged: (value) {
                      this.userNumber = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: priceBikeController,
                    decoration:
                        InputDecoration(hintText: 'Enter price of bike'),
                    onChanged: (value) {
                      this.carPrice = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: bikeNameController,
                    decoration: InputDecoration(hintText: 'Enter bike name'),
                    onChanged: (value) {
                      this.carModel = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: bikeColorController,
                    decoration: InputDecoration(hintText: 'Enter bike color'),
                    onChanged: (value) {
                      this.carColor = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: descriptionBikeController,
                    decoration:
                        InputDecoration(hintText: 'Enter description of bike'),
                    onChanged: (value) {
                      this.description = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter url of image'),
                    onChanged: (value) {
                      this.urlImage = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(hintText: 'Enter location'),
                    onChanged: (value) {
                      this.carlocation = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  child: Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                child: Text(
                  "Update Now",
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Map<String, dynamic> carData = {
                    'userName': this.userName,
                    'userNumber': this.userNumber,
                    'carPrice': this.carPrice,
                    'carModel': this.carModel,
                    'carColor': this.carColor,
                    'carLocation': this.carlocation,
                    'description': this.description,
                    'urlImage': this.urlImage,
                  };
                  carObj.updateData(selectedDoc, carData).then((value) {
                    print("Data updated successfully.");
                  }).catchError((onError) {
                    print(onError);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () {
        Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      },
      icon: Icon(Icons.arrow_back, color: Colors.white),
    );
  }

  Widget _buildUserImage() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(
              adUserImageUrl,
            ),
            fit: BoxFit.fill),
      ),
    );
  }

  getResults() {
    FirebaseFirestore.instance
        .collection('cars')
        .where("uId", isEqualTo: widget.sellerId)
        .get()
        .then((results) {
      setState(() {
        cars = results;
        adUserName = cars.docs[0]['userName'];
        bikecolor = cars.docs[0]['carColor'];
        bikelocation = cars.docs[0]['carModel'];
        bikeprice = cars.docs[0]['carPrice'];
        bikedescription = cars.docs[0]['description'];
        userNumber = cars.docs[0]['userNumber'];
        adUserImageUrl = cars.docs[0]['imgPro'];
      });
      nameController.text = adUserName;
      phoneController.text = userNumber;
      bikeColorController.text = bikecolor;
      priceBikeController.text = bikeprice;
    });
  }

  Widget showCarsList() {
    if (cars != null) {
      return ListView.builder(
        itemCount: cars.docs.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context, i) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Route newRoute = MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                sellerId: cars.docs[i]['uId'],
                              ));
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              cars.docs[i]['imgPro'],
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  title: Text(cars.docs[i]['userName']),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        cars.docs[i]['carLocation'],
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Icon(
                        Icons.location_pin,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  trailing: cars.docs[i]['uId'] == userId
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (cars.docs[i]['uId'] == userId) {
                                  showDialogForUpdateData(cars.docs[i].id);
                                }
                              },
                              child: Icon(
                                Icons.edit_outlined,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                                onDoubleTap: () {
                                  if (cars.docs[i]['uId'] == userId) {
                                    carObj.deleteData(cars.docs[i].id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext c) =>
                                                HomeScreen()));
                                  }
                                },
                                child: Icon(Icons.delete_forever_sharp)),
                          ],
                        )
                      : Row(mainAxisSize: MainAxisSize.min, children: []),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    cars.docs[i]['urlImage'],
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'NRS.' + cars.docs[i]['carPrice'],
                    style: TextStyle(
                      fontFamily: "Bebas",
                      letterSpacing: 2.0,
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.motorcycle_outlined),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              child: Text(cars.docs[i]['carModel']),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.watch_later_outlined),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              //child: Text(cars.docs[i]['time'].toString()),
                              child: Text(
                                  tAgo.format((cars.docs[i]['time']).toDate())),
                              alignment: Alignment.topLeft,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.brush_outlined),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              child: Text(cars.docs[i]['carColor']),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone_android),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              //child: Text(cars.docs[i]['time'].toString()),
                              child: Text(cars.docs[i]['userNumber']),
                              alignment: Alignment.topRight,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    cars.docs[i]['description'],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Text('Loading...');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // leading: _buildBackButton(),
        title: Row(
          children: [
            _buildUserImage(),
            SizedBox(
              width: 10,
            ),
            Text('Edit your bikes'),
          ],
        ),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.redAccent,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      drawer: AppDrawer(usere: userEmail, usern: userNames),
      body: Center(
        child: Container(
          width: _screenWidth,
          child: showCarsList(),
        ),
      ),
    );
  }
}
