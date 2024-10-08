import 'package:budget_buddy/dialogs/take_picture_screen.dart';
import 'package:budget_buddy/objects/item.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:budget_buddy/widgets/buttons.dart';

typedef ItemsListDeletedCallback = Function(Item item);

class InfoDialog extends StatefulWidget {
  const InfoDialog(
      {super.key,
      required this.item,
      required this.onDeleteItem,
      required this.cam});

  final ItemsListDeletedCallback onDeleteItem;
  final Item item;
  final cam;

  @override
  State<InfoDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<InfoDialog> {
  final ButtonStyle cameraStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  String billName = "";
  String textString = "";
  DateTime? moment = DateTime.now();
  double amount = 0.0;
  XFile? img;

  @override
  Widget build(BuildContext context) {
    MoneyFormatter fmf = MoneyFormatter(amount: widget.item.payment);
    String fo = fmf.output.symbolOnLeft;

    return AlertDialog(
      title: const Center(child: Text('Bill Information')),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text("Name: ${widget.item.name}"),
        Text("Date: ${DateFormat('MM-dd-yy').format(widget.item.date!)}"),
        Text("Amount: $fo"),
        Text("Frequency: ${widget.item.frequency}"),
        ElevatedButton(
            key: const Key("CameraButton2"),
            style: cameraStyle,
            child: const Text('Add/Show Picture'),
            onPressed: () async {
              if (widget.item.image != null) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return DisplayPictureScreen(image: widget.item.image!);
                    });
              }
              if (widget.item.image == null) {
                final result = await showDialog<XFile>(
                    context: context,
                    builder: (_) {
                      return TakePictureScreen(
                          camera: widget.cam); // needs to return an image/path
                    });
                widget.item.image = result;
              }
            }),
      ]),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          EvilButton(
            key: const Key("DeleteButton"),
            child: const Text('Delete Bill'),
            onPressed: () {
              showDialog(
                context: context, 
                builder: (_) {
                  return DeleteDialog(item: widget.item, onDeleteItem: widget.onDeleteItem);
                });
            },
          ),
          const SizedBox(width: 10),
          GoodButton(
            key: const Key("CloseButton"),
            child: const Text('Close'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
        ]),
      ],
    );
  }
}

class DeleteDialog extends StatefulWidget {
  const DeleteDialog(
      {super.key,
      required this.item,
      required this.onDeleteItem,});

  final ItemsListDeletedCallback onDeleteItem;
  final Item item;

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center (child: Text('Delete this bill?')),
      content: const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text("This cannot be undone."),
      ]),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          EvilButton(
            key: const Key("Delete"),
            child: const Text('Yes'),
            onPressed: () {
              widget.onDeleteItem(widget.item);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 10),
          GoodButton(
            key: const Key("Dontlete"),
            child: const Text('No'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
          ),
        ]) 
      ],
    );
  }
}
