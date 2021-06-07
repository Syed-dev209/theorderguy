import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const PrimaryColor = Color(0xffDF182D);
const logTextStyle =
    TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500);
const logTextStyleblack =
    TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500);
const sponsored = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.5,
);
const radius = 1500000.0;

checksponsoreindex(var index, var list) {
  var eyeonlistindex;
  eyeonlistindex = list[index].sponsored.toString() == "1";
  if (!eyeonlistindex) {
    eyeonlistindex = double.parse(
            list[index].distance.toString().split(" ").first.toString()) <=
        radius;
  }

  return eyeonlistindex;
}

// const popback = Navigator.pop(context);
