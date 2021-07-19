import 'package:bike_mart/SearchBike.dart';
import 'package:bike_mart/authenticationScreen.dart';
import 'package:bike_mart/functions.dart';
import 'package:bike_mart/globalVar.dart';
import 'package:bike_mart/profileScreen.dart';
import 'package:bike_mart/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as tAgo;

import 'app_drawer.dart';
import 'appbarcolor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController priceOfBike = TextEditingController();
  TextEditingController bikeName = TextEditingController();
  TextEditingController bikeColor = TextEditingController();
  TextEditingController descriptionofBike = TextEditingController();
  TextEditingController location = TextEditingController();
  bool _validate = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  String userNumber;
  String carPrice;
  String carModel;
  String carColor;
  String description;
  String urlImage;
  String carlocation;
  QuerySnapshot cars;
  QuerySnapshot userss;

  carMethods carObj = new carMethods();

  Future<bool> showDialogForAddingData() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final GlobalKey<ScaffoldState> _scaffoldKey =
              GlobalKey<ScaffoldState>();
          return AlertDialog(
            title: Text(
              "Post a new Ad",
              style: TextStyle(
                  fontSize: 24, fontFamily: "Bebas", letterSpacing: 2.0),
            ),
            content: Scaffold(
              key: _scaffoldKey,
              body: Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: name,
                          //ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field is empty';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            // errorText:
                            //     _validate ? 'Value Can\'t Be Empty' : null,
                          ),
                          onChanged: (value) {
                            this.userName = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          controller: phoneNumber,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          //ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field is empty';
                            }
                          },

                          decoration: InputDecoration(
                              hintText: 'Enter your phone number'),
                          onChanged: (value) {
                            this.userNumber = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          controller: priceOfBike,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field is empty';
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: 'Enter price of bike',
                            errorText:
                                _validate ? 'Value Can\'t Be Empty' : null,
                          ),
                          onChanged: (value) {
                            this.carPrice = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          // controller: bikeName,
                          // ignore: missing_return
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Field is empty';
                          //   }
                          // },
                          decoration:
                              InputDecoration(hintText: 'Enter bike name'),
                          onChanged: (value) {
                            this.carModel = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          controller: bikeColor,
                          //ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field is empty';
                            }
                          },
                          decoration:
                              InputDecoration(hintText: 'Enter bike color'),
                          onChanged: (value) {
                            this.carColor = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          controller: descriptionofBike,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field is empty';
                            }
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter description of bike'),
                          onChanged: (value) {
                            this.description = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter url of image'),
                          onChanged: (value) {
                            this.urlImage = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                        TextFormField(
                          controller: location,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field is empty';
                            }
                          },
                          decoration:
                              InputDecoration(hintText: 'Enter location'),
                          onChanged: (value) {
                            this.carlocation = value;
                          },
                        ),
                        SizedBox(height: 2.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  child: Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    setState(() {
                      phoneNumber.text = "";
                      priceOfBike.text = "";
                      bikeName.text = "";
                      bikeColor.text = "";
                      descriptionofBike.text = "";
                      location.text = "";
                      name.text = "";
                    });

                    Navigator.pop(context);
                  }),
              ElevatedButton(
                child: Text(
                  "Add Now",
                ),
                onPressed: () {
                  setState(() {
                    if (formKey.currentState.validate()) ;
                  });

                  if (userName.isNotEmpty ||
                      userNumber.isNotEmpty ||
                      carPrice.isNotEmpty ||
                      carModel.isNotEmpty ||
                      carColor.isNotEmpty ||
                      carlocation.isNotEmpty ||
                      description.isNotEmpty ||
                      urlImage.isNotEmpty ||
                      userImageUrl.isNotEmpty) {
                    Map<String, dynamic> carData = {
                      'userName': this.userName,
                      'uId': userId,
                      'userNumber': this.userNumber,
                      'carPrice': this.carPrice,
                      'carModel': this.carModel,
                      'carColor': this.carColor,
                      'carLocation': this.carlocation,
                      'description': this.description,
                      'urlImage': this.urlImage,
                      'imgPro': userImageUrl,
                      'time': DateTime.now(),
                    };
                    carObj.addData(carData).then(
                      (value) {
                        print("Data added successfully.");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                    ).catchError((onError) {
                      print(onError);
                    });
                  } else {}
                },
              ),
            ],
          );
        });
  }

  getMydata() {
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;
    carObj.getData().then((results) {
      setState(() {
        cars = results;
      });
    });

    getMydata();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

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
                    leading: Container(
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
                    title: Text(cars.docs[i]['userName']),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cars.docs[i]['carLocation'],
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
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
                              SizedBox(
                                width: 20,
                              ),
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
                                child: Text(tAgo
                                    .format((cars.docs[i]['time']).toDate())),
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

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.refresh, color: Colors.white),
        //   onPressed: () {
        //     Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
        //     Navigator.pushReplacement(context, newRoute);
        //   },
        // ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              getMydata();

              print(userNames);

              Route newRoute = MaterialPageRoute(builder: (_) => EditProfile());
              Navigator.push(context, newRoute);
            },
            // onPressed: () {
            //   Route newRoute =
            //       MaterialPageRoute(builder: (_) => ProfileScreen());
            //   Navigator.pushReplacement(context, newRoute);
            // },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Route newRoute = MaterialPageRoute(builder: (_) => SearchBike());
              Navigator.pushReplacement(context, newRoute);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.search, color: Colors.white),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     auth.signOut().then((_) {
          //       Route newRoute =
          //           MaterialPageRoute(builder: (_) => AuthenticationScreen());
          //       Navigator.pushReplacement(context, newRoute);
          //     });
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Icon(Icons.login_outlined, color: Colors.white),
          //   ),
          // ),
        ],
        flexibleSpace: colorapp,
        title: Text(
          ("Home Page"),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(usere: userEmail, usern: userNames),
      body: Center(
        child: Container(
          width: _screenWidth,
          child: showCarsList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Post',
        child: Icon(Icons.add),
        onPressed: () {
          showDialogForAddingData();
        },
      ),
    );
  }
}
