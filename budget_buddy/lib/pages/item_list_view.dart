import 'package:budget_buddy/objects/item.dart';
import 'package:flutter/material.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({
    super.key,
  });
  @override
  State<StatefulWidget> createState() {
    return ItemListViewState();
  }
}

//TODO: I need to create a list_object widget so that I can better display information of the items

class ItemListViewState extends State<ItemListView> {
  final List<Item> items = [Item(name: "Bill 1")];

  void _handleNewItem(Item item) {
    setState(() {
      items.add(item);
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Buddy"),
        centerTitle: true,
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text(item.name),
              leading: const CircleAvatar(
                // This might be the picture of the item
                backgroundColor: Colors.green,
              ),
              onTap: () {
                //use navigator to open up a details dialog box.

                //temp function
                _handleDeleteItem(item);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (_) {
          //     return dialogWidgetName;
          //   }
          // );

          //temp function
          _handleNewItem(Item(name: "Bill 5"));
        },
        tooltip: "Add New Item",
        child: const Icon(Icons.add),
      ),
    );
  }
}
