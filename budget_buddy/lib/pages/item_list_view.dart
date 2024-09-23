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

class ItemListViewState extends State<ItemListView> {
  final List<Item> items = [Item(name: "Bill 1")];

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
              });
        },
      ),
    );
  }
}
