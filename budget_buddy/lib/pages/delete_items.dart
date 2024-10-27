import 'package:budget_buddy/dialogs/add_dialog.dart';
import 'package:budget_buddy/dialogs/delete.dialog.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:budget_buddy/widgets/budget_item.dart';
import 'package:flutter/material.dart';
typedef ItemsListChangedCallback = Function(Item item);
typedef ItemsListDeletedCallback = Function(Item item);

class DeleteItemListView extends StatefulWidget {
  DeleteItemListView(
      {super.key,
      required this.items,
      required this.onDeleteItem,});

  final List<Item> items;
  final ItemsListDeletedCallback onDeleteItem;
  List<bool> selected = [];

  


  @override
  State<StatefulWidget> createState() {
    return DeleteItemListViewState();
  }
}

class DeleteItemListViewState extends State<DeleteItemListView> {
  void setSelected(List<bool> selected, List<Item> items){
    for(var item in items){
      selected.add(false);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    setSelected(widget.selected, widget.items);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Buddy"),
        centerTitle: true,
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];

          return ListTile(
            title: Text(widget.items[index].name),
            leading: Checkbox(
              value: widget.selected[index],
              onChanged: (bool? value) {
                setState(() {
                  widget.selected[index] = value as bool;
                });
              },
            ),
          );
        },
      ),
     
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return DeleteAll(
                    itemsToDelete: widget.items, onDeleteItem: widget.onDeleteItem, selected: widget.selected,);
              });

          //temp function. will be replaced when dialog windows are made.
          Navigator.pop;
        },
        tooltip: "Delete item(s)",
        child: const Icon(Icons.remove),
      ),
    );
  }
}
