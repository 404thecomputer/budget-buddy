class Item {
  String name;
  DateTime? date;
  double? payment = 0.0;
  int? confirmationNumber = 0;

  Item({required this.name, required this.date, this.payment, this.confirmationNumber});
}
