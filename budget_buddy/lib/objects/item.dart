import 'package:camera/camera.dart';

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
