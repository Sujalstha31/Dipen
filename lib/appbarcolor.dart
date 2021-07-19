import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final colorapp = Container(
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
);
