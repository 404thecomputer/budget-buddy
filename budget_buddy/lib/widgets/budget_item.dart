import 'package:budget_buddy/dialogs/info_dialog.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

typedef ItemsListDeletedCallback = Function(Item item);

class BudgetItem extends StatelessWidget {
  const BudgetItem(
      {super.key,
      required this.item,
      required this.onDeleteItem,
      required this.onCompleteItem,
      required this.cam});

  final Item item;
  final ItemsListDeletedCallback onDeleteItem;
  final Function(Item) onCompleteItem;
  final cam;

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
    String freq = item.frequency ?? "One Time";
    return ListTile(
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: CircleAvatar(
          // This might be the picture of the item
          backgroundColor: item.isComplete ? Colors.grey : item.date!.isBefore(DateTime.now()) ? Colors.red : Colors.green,
        ),
        subtitle: Text(
          "${DateFormat('MM-dd-yy').format(item.date!)} | $fo | $freq | $pictureBool${item.isComplete ? " | Completed" : ""}"
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!item.isComplete)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => onCompleteItem(item),
              ),
          ],
        ),
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
