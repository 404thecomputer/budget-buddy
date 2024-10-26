import 'package:budget_buddy/dialogs/info_dialog.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:budget_buddy/widgets/buttons.dart';
import 'package:flutter/material.dart';

class DeleteAll extends StatefulWidget{
  DeleteAll({super.key, required this.itemsToDelete, required this.onDeleteItem});


  List<Item> itemsToDelete;

  final ItemsListDeletedCallback onDeleteItem;





  @override
  State<DeleteAll> createState() => _DeleteAllState();
}

class _DeleteAllState extends State<DeleteAll> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Delete All Items?')),

      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          EvilButton(
            key: const Key("CancelButton"),
            child: const Text('Cancel'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          const SizedBox(width: 10),
          GoodButton(
            key: const Key("OKButton"),
            child: const Text('OK'),
            onPressed: () {
              setState(() {
                for(var item in widget.itemsToDelete){
                widget.onDeleteItem(item); }
                Navigator.pop(context);
              });
            },
          ),
        ]),
      ],
    );
    
  }
}