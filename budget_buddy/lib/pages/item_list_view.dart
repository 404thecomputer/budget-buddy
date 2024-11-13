import 'package:budget_buddy/dialogs/add_dialog.dart';
import 'package:budget_buddy/dialogs/delete.dialog.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:budget_buddy/pages/delete_items.dart';
import 'package:budget_buddy/widgets/budget_item.dart';
import 'package:flutter/material.dart';

typedef ItemsListChangedCallback = Function(Item item);
typedef ItemsListDeletedCallback = Function(Item item);

class ItemListView extends StatefulWidget {
  const ItemListView(
      {super.key,
      required this.items,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.onCompleteItem,
      required this.cam});

  final List<Item> items;
  final ItemsListChangedCallback onListChanged;
  final ItemsListDeletedCallback onDeleteItem;
  final Function(Item) onCompleteItem;
  final cam;

  @override
  State<StatefulWidget> createState() {
    return ItemListViewState();
  }
}

class ItemListViewState extends State<ItemListView> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final displayedItems = widget.items.where((item) => 
      item.isComplete == showCompleted
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Buddy"),
        centerTitle: true,
        actions: [
          // Toggle completed button
          TextButton.icon(
            onPressed: () {
              setState(() {
                showCompleted = !showCompleted;
              });
            },
            icon: Icon(
              showCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: Colors.black,
            ),
            label: const Text(
              'Show Completed',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: displayedItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = displayedItems[index];

          return BudgetItem(
              item: item, 
              onDeleteItem: widget.onDeleteItem, 
              onCompleteItem: widget.onCompleteItem,
              cam: widget.cam);
        },
      ),
      //Changed floatingActionButton to persistentFooterButtons in order to have a delete button next to the add button
      persistentFooterButtons: [
      FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return ItemDialog(
                    onListChanged: widget.onListChanged, cam: widget.cam);
              });

          //temp function. will be replaced when dialog windows are made.
        },
        tooltip: "Add New Item",
        child: const Icon(Icons.add),
      ),

      //This is the new delete button
      FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeleteItemListView(items: widget.items, onDeleteItem: widget.onDeleteItem)
            )
          );

        },
        tooltip: "Delete item(s)",
        heroTag: null,
        child: const Icon(Icons.remove),
        
      ),
      ],
    );
  }
}
