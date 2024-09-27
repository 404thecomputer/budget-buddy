import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Item {
  String name;
  DateTime? date;
  double payment = 0.0;
  String? frequency;
  XFile? image;

  Item(
      {required this.name,
      required this.date,
      required this.payment,
      this.image,
      this.frequency});
}
