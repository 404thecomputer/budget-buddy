import 'package:budget_buddy/objects/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

typedef ItemsListDeletedCallback = Function(Item item);

class BudgetItem extends StatelessWidget {
  const BudgetItem({super.key, required this.item, required this.onDeleteItem});

  final Item item;
  final ItemsListDeletedCallback onDeleteItem;

  @override
  Widget build(BuildContext context) {
    MoneyFormatter fmf = MoneyFormatter(amount: item.payment);

    String fo = fmf.output.symbolOnLeft;
    return ListTile(
        title: Text(item.name),
        leading: const CircleAvatar(
          // This might be the picture of the item
          backgroundColor: Colors.green,
        ),
        subtitle: Text(
            "${item.confirmationNumber} | ${DateFormat('MM-dd-yy').format(item.date!)} | $fo"),
        onTap: () {
          //open a dialog box

          onDeleteItem(item);
        });
  }
}
