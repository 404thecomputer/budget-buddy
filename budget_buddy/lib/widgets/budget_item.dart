import 'package:budget_buddy/objects/item.dart';
import 'package:flutter/material.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(item.name),
        leading: const CircleAvatar(
          // This might be the picture of the item
          backgroundColor: Colors.green,
        ),
        subtitle: const Text("Potential data"),
        onTap: () {
          //open a dialog box

          // widget.onDeleteItem(item);
        });
  }
}
