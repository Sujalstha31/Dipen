import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_drawer.dart';
import 'appbarcolor.dart';
import 'globalVar.dart';

class Maps extends StatefulWidget {
  @override
  MapState createState() => MapState();
}

class MapState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    super.initState();
  }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: new Center(
            child: new Text('Service Center', textAlign: TextAlign.center)),
        actions: <Widget>[],
        flexibleSpace: colorapp,
      ),
      drawer: AppDrawer(usere: userEmail, usern: userNames),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus, color: Color(0xFF2196F3)),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus, color: Color(0xFF2196F3)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(27.7172, 85.3240), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(27.7172, 85.3240), zoom: zoomVal)));
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 110.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes('assets/imagesForMap/royal.png', 27.732094,
                  85.301665, "Royal Enfield "),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes('assets/imagesForMap/yamaha.png', 27.696050,
                  85.309428, "Yamaha"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes('assets/imagesForMap/ktm.png', 27.7147, 85.3355,
                  "KTM Service Center"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes('assets/imagesForMap/beneli.jpg', 27.720423,
                  85.327130, "Benelli Service Center"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes('assets/imagesForMap/cf.png', 27.720265, 85.337966,
                  "CF MOTO"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes('assets/imagesForMap/bajaj.png', 27.691122,
                  85.310399, "BAJAJ"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes('assets/imagesForMap/honda.png', 27.701838,
                  85.324353, "Honda"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0xFF000000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 170,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image.asset(
                        _image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            restaurantName,
            style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 3.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Nepal",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Closed-Saturday \u00B7",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
        Container(
            child: Text(
          "Opens 10:00 AM Sun-Fri",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(27.7172, 85.3240), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          beneliMarker,
          hondaMarker,
          bajajMarker,
          cfMarker,
          tvsMarker,
          royalEnfieldMarker,
          yamahamarker,
          ktmMarker
        },
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

Marker royalEnfieldMarker = Marker(
  markerId: MarkerId('Royal Enfield'),
  position: LatLng(27.732094, 85.301665),
  infoWindow: InfoWindow(title: 'Royal Enfield'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueGreen,
  ),
);

Marker yamahamarker = Marker(
  markerId: MarkerId('Yamaha'),
  position: LatLng(27.696050, 85.309428),
  infoWindow: InfoWindow(title: 'Yamaha Service Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
Marker ktmMarker = Marker(
  markerId: MarkerId('bluehill'),
  position: LatLng(27.7147, 85.3355),
  infoWindow: InfoWindow(title: 'KTM Service Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker beneliMarker = Marker(
  markerId: MarkerId('beneli'),
  position: LatLng(27.720423, 85.327130),
  infoWindow: InfoWindow(title: 'Beneli Service Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker bajajMarker = Marker(
  markerId: MarkerId('newyork2'),
  position: LatLng(
    27.691122,
    85.310399,
  ),
  infoWindow: InfoWindow(title: 'Bajaj Service Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker cfMarker = Marker(
  markerId: MarkerId('CF MOTO'),
  position: LatLng(27.720265, 85.337966),
  infoWindow: InfoWindow(title: 'CF MOTO Service Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueBlue,
  ),
);
Marker tvsMarker = Marker(
  markerId: MarkerId('TVS'),
  position: LatLng(27.716702, 85.327083),
  infoWindow: InfoWindow(title: 'TVS Service Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueBlue,
  ),
);
Marker hondaMarker = Marker(
  markerId: MarkerId('Honda'),
  position: LatLng(27.701838, 85.324353),
  infoWindow: InfoWindow(title: 'Honda Service Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
