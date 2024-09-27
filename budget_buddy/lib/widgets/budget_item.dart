import 'package:budget_buddy/dialogs/info_dialog.dart';
import 'package:budget_buddy/dialogs/take_picture_screen.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

typedef ItemsListDeletedCallback = Function(Item item);

class BudgetItem extends StatelessWidget {
  const BudgetItem({super.key, required this.item, required this.onDeleteItem, required this.cam});

  final Item item;
  final ItemsListDeletedCallback onDeleteItem;
  final CameraDescription cam;

  @override
  Widget build(BuildContext context) {
    MoneyFormatter fmf = MoneyFormatter(amount: item.payment);
    String pictureBool = "";
    if (item.image == null) {
      pictureBool = "No Image";
    }
    if (item.image != null) {
      pictureBool = "Image Attached";
    }
    String fo = fmf.output.symbolOnLeft;
    String freq = item.frequency!;
    return ListTile(
        title: Text(item.name),
        leading: const CircleAvatar(
          // This might be the picture of the item
          backgroundColor: Colors.green,
        ),
        subtitle: Text("${DateFormat('MM-dd-yy').format(item.date!)} | $fo | $freq | $pictureBool"),
        onTap: () {
          //open a dialog box
          showDialog(
              context: context,
              builder: (_) {
                return InfoDialog(
                    item: item, onDeleteItem: onDeleteItem, cam: cam);
              });
        });
  }
}
